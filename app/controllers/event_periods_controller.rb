class EventPeriodsController < ApplicationController
  # TODO: Authenticate! - put in specs
  # before_action :authenticate_user!

  # GET /event/:event_id/event_periods/new
  def new
    @event = Event.find(params[:event_id])
    @event_period = EventPeriod.new
  end

  # POST /event/:event_id/event_periods
  def create
    @event = Event.find(params[:event_id])

    @event_period = EventPeriod.new(event_period_params)
    @event_period.event_seed = @event.event_seeds.last # TODO: THIS IS WRONG!!!! TEMPORARY

    if @event_period.save
      redirect_to event_path(@event)
    else
      render :new
    end
  end

  private def event_period_params
    params.require(:event_period).permit(
      :start_date,
      :frequency
    )
  end
end
