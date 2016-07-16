class DatesController < ApplicationController
  before_action :authenticate_user!

  # GET /events/:id/dates/new
  def new
    @event_instance = EventInstance.new
  end

  # POST /events/:id/dates
  def create
    event = Event.find(params.require(:event_id))
    # TODO - pick the right seed/move this logic into a model
    event_seed = event.event_seeds.last
    @event_instance = EventInstance.new(
      event_seed: event_seed,
      date: event_instance_params[:date],
    )
    if @event_instance.save
      redirect_to event
    else
      render :new
    end
  end

private

  def event_instance_params
    params.require(:event_instance).permit(
      :date
    )
  end
end
