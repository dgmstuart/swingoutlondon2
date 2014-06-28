class EventsController < ApplicationController
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
    redirect_to @event
  end

private

  def event_params
    params.require(:event).permit(:url)
  end

end