class EventsController < ApplicationController
  # GET /events
  def index
    @events = Event.all
  end

  # GET /events/:id
  def show
    @event = Event.find(params[:id])
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # POST /events
  def create
    @event = Event.create(event_params)
    flash[:success] = "New event created"

    if @event.repeating?
      # TODO: Smelly - it isn't clear here that @event.generate is doing the creation
      dates = [@event.date] + @event.generate
      date_string = dates.map(&:to_s).join(", ") # TODO: Better way of doing this - in one step?
      flash[:success] += ". #{dates.count} instances created: #{date_string}"
    end

    redirect_to @event
  end

private

  def event_params
    params.require(:event).permit(:url, :frequency, :date)
  end

end