# frozen_string_literal: true

class EventItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_event_organizer, only: %i[new create edit update destroy event_organizer_events]
  before_action :check_customer, only: %i[customer_event_items]
  before_action :find_event_item, only: %i[show edit update destroy]

  def index
    @event_items = EventItem.accessible_by(current_ability).order(date: :asc)
    respond_to_format(@event_items)
  end

  def show
    respond_to_format(@event_item)
  end

  def customer_event_items
    @customer_event_items = Purchase.joins(ticket: :event_item).where(customer_id: current_user.customer.id)
  end

  def event_organizer_events
    @event_organizer_events = current_user.event_organizer.event_items
  end

  def new
    @event_item = EventItem.new
    @event_item.build_ticket
  end

  def create
    @event_item = build_event_item
    attach_image

    if can?(:create, EventItem) && @event_item.save
      create_ticket_or_redirect
    else
      redirect_with_error(new_event_item_path, "Your event was not created.", @event_item.errors)
    end
  end

  def edit
    check_edit_permissions
  end

  def update
    if @event_item.update(event_item_params)
      redirect_to @event_item, notice: "Your event was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    if can_destroy_event_item?
      @event_item.destroy
      redirect_to event_items_url, notice: "Your event was successfully destroyed."
    else
      redirect_to root_path
    end
  end

  def by_type
    @event_type = params[:event_type]
    @event_items = EventItem.present_events.where(event_type: @event_type)
    respond_to_format(@event_items)
  end

  private

  def find_event_item
    @event_item = EventItem.accessible_by(current_ability).find(params[:id])
  end

  def check_event_organizer
    redirect_if_not_allowed(current_user.event_organizer?, "You don't have permission to do this action")
  end

  def check_customer
    redirect_if_not_allowed(current_user.customer?, "You don't have permission to do this action")
  end

  def check_edit_permissions
    return if editable_event?

    flash[:error] = "You cannot edit an event that has already been purchased."
    redirect_to event_item_path(@event_item)
  end

  def editable_event?
    !@event_item.has_succeeded_purchases? && !@event_item.past_event? && @event_item.status == "draft"
  end

  def event_item_params
    params.require(:event_item).permit(:title, :description, :date, :time, :location, :status, :image, :event_type,
                                       ticket_attributes: %i[price quantity_available])
  end

  def build_event_item
    current_user.event_organizer.event_items.build(event_item_params)
  end

  def attach_image
    @event_item.image.attach(params[:event_item][:image]) if params[:event_item][:image]
  end

  def can_destroy_event_item?
    can?(:destroy, @event_item) && !@event_item.has_succeeded_purchases?
  end

  def create_ticket_or_redirect
    @event_item.build_ticket(event_item_params[:ticket_attributes])
    if @event_item.ticket.save
      redirect_to @event_item, notice: "Your event #{@event_item.title} was successfully created."
    else
      redirect_with_error(new_event_item_path, "Your ticket was not created.", @event_item.errors)
    end
  end

  def redirect_with_error(path, message, errors)
    redirect_to path, alert: "#{message} #{errors.full_messages.join(',')}"
  end

  def redirect_if_not_allowed(condition, message)
    redirect_to root_path, alert: message unless condition
  end

  def respond_to_format(items)
    respond_to do |format|
      format.html
      format.json { render json: items }
    end
  end
end
