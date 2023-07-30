class EventItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_event_organizer, only: %i[new create edit update destroy event_organizer_events]
  before_action :check_customer, only: %i[customer_event_items]

  def index
    @event_items = EventItem.published.accessible_by(current_ability).order(date: :asc)

    respond_to do |format|
      format.html
      format.json { render json: @event_items }
    end
  end

  def show
    @event_item = EventItem.accessible_by(current_ability).find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @event_item }
    end
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
    @event_item = current_user.event_organizer.event_items.build(event_item_params)
    if params[:event_item][:image]
      @event_item.image.attach(params[:event_item][:image])
    end
    
    if can?(:create, EventItem) && @event_item.save
      @event_item.build_ticket(event_item_params[:ticket_attributes])
      if @event_item.ticket.save
        redirect_to @event_item, notice: "Your event #{@event_item.title} was successfully created."
      else
        redirect_to new_event_item_path,
                    alert: "Your ticket was not created. #{@event_item.errors.full_messages.join(',')}"
      end
    else
      redirect_to new_event_item_path,
                  alert: "Your event was not created. #{@event_item.errors.full_messages.join(',')}"
    end
  end

  def edit
    @event_item = current_user.event_organizer.event_items.find(params[:id])
    authorize! :update, @event_item
  
    if @event_item.has_succeeded_purchases? || @event_item.past_event? || @event_item.status != "draft"
      flash[:error] = "You cannot edit an event that has already been purchased."
      redirect_to event_item_path(@event_item)
    end
  end
  
  def update
    @event_item = current_user.event_organizer.event_items.find(params[:id])
    authorize! :update, @event_item
  
    if @event_item.update(event_item_params)
      redirect_to @event_item, notice: "Your event was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @event_item = current_user.event_organizer.event_items.find(params[:id])
    if can?(:destroy, @event_item) && !@event_item.has_succeeded_purchases?
      @event_item.destroy
      redirect_to event_items_url, notice: "Your event was successfully destroyed."
    else
      redirect_to root_path
    end
  end

  def by_type
    @event_type = params[:event_type]
    @event_items = EventItem.present_events.where(event_type: @event_type)
    respond_to do |format|
      format.html
      format.json { render json: @event_items }
    end
  end

  private

  def check_event_organizer
    redirect_to root_path, alert: "You don't have permission to do this action" unless current_user.event_organizer?
  end

  def check_customer
    redirect_to root_path, alert: "You don't have permission to do this action" unless current_user.customer?
  end

  def event_item_params
    params.require(:event_item).permit(:title, :description, :date, :time, :location, :status, :image, :event_type,
                                       ticket_attributes: %i[price quantity_available])
  end
end
