class EventPeriodsController < ApplicationController
  # TODO: Authenticate! - put in specs
  # before_action :authenticate_user!

  # GET /event/:event_id/event_periods/:id/edit
  def edit
    @event = Event.find(params[:event_id])
    @event_period = EventPeriod.find(params[:id])
  end

  # PATCH /event/:event_id/event_periods/:id
  def update
    @event_period = EventPeriod.find(params[:id])

    event_period_params = params.require(:event_period).permit(:end_date)

    if @event_period.update(event_period_params)
      redirect_to event_path(@event_period.event)
    else
      @event = Event.find(params[:event_id])
      render :edit
    end
  end

  # GET /event/:event_id/event_periods/new
  def new
    @event = Event.find(params[:event_id])
    @event_period = EventPeriod.new
  end

  # POST /event/:event_id/event_periods
  def create
    @event = Event.find(params[:event_id])

    result = EventPeriodCreator.new.call(event_period_params, @event)
    @event_period = result.event_period

    if result.success?
      redirect_to event_path(@event)
    else
      render :new
    end
  end

  class EventPeriodCreator
    def call(event_period_params, event)
      event_period = EventPeriod.new(event_period_params)
      event_period.event_seed = event.event_seeds.last # TODO: THIS IS WRONG!!!! TEMPORARY

      previous_period = event.event_periods.last || NullEventPeriod.new
      adder = EventPeriodAdder.new(event_period, previous_period)

      if adder.add
        Success.new(event_period)
      else
        Failure.new(adder.new_period)
      end
    end

    Success = Struct.new(:event_period) do
      def success?
        true
      end
    end

    Failure = Struct.new(:event_period) do
      def success?
        false
      end
    end
  end

  private def event_period_params
    params.require(:event_period).permit(
      :start_date,
      :frequency
    )
  end
end
