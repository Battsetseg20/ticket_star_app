class EventItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_event_organizer, only: %i[new create edit update destroy]

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
  end

  def update
    @event_item = current_user.event_organizer.event_items.find(params[:id])
    if can?(:update, @event_item) && @event_item.update(event_item_params)
      redirect_to @event_item, notice: "Your event was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @event_item = current_user.event_organizer.event_items.find(params[:id])
    if can?(:destroy, @event_item)
      @event_item.destroy
      redirect_to event_items_url, notice: "Your event was successfully destroyed."
    else
      redirect_to root_path
    end
  end

  def by_type
    @event_items = EventItem.published.where(event_type: event_items_params[:event_type])
  end

  def hot_events
    @event_items = EventItem.hot_events.order(date: :asc)
  end

  def latest_events
    @event_items = EventItem.latest_events.order(date: :asc)
  end

  def sold_out
    @event_items = EventItem.sold_out.order(date: :asc)
  end
  
  def past_events
    @event_items = EventItem.past_events.order(date: :asc)
  end

  private

  def check_event_organizer
    redirect_to root_path, alert: "You don't have permission to do this action" unless current_user.event_organizer?
  end

  def event_item_params
    params.require(:event_item).permit(:title, :description, :date, :time, :location, :status, :image, :event_type,
                                       ticket_attributes: %i[price quantity_available])
  end
end
