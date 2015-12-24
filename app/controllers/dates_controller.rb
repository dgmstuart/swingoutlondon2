class DatesController < ApplicationController
  before_action :authenticate_user!

  # GET /events/:id/dates/new
  def new
    @event_period = EventPeriod.new
  end

  # POST /events/:id/dates
  def create
    # TODO: needs strong params here?
    event = Event.find(params[:event_id])
    # TODO - pick the right seed/move this logic into a model
    event_seed = event.event_seeds.last
    @event_period = EventPeriod.new(event_period_params)
    @event_period.event_seed = event_seed
    @event_period.frequency = 0
    if @event_period.save
      # TODO: FLASH?
      # TODO: Don't generate straight away?
      @event_period.generate
      redirect_to @event_period.event
    else
      render :new
    end
  end

private

  def event_period_params
    params.require(:event_period).permit(
      :start_date
    )
  end
end
