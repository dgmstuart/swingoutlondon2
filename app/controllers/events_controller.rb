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
      number_created = @event.generate
      flash[:success] += ". #{number_created + 1} instances created."
    end


    redirect_to @event
  end

private

  def event_params
    params.require(:event).permit(:url, :frequency, :date)
  end

end