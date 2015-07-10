class EventGeneratorsController < ApplicationController
  # TODO: Authenticate! - put in specs
  # before_action :authenticate_user!

  # GET /event/:event_id/event_generators/:id/edit
  def edit
    @event = Event.find(params[:event_id])
    @event_generator = EventGenerator.find(params[:id])
  end

  # PATCH /event/:event_id/event_generators/:id
  def update
    @event_generator = EventGenerator.find(params[:id])

    event_generator_params = params.require(:event_generator).permit(:end_date)
    # TODO - failure case

    @event_generator.update!(event_generator_params)

    redirect_to event_path(@event_generator.event)
  end

  # GET /event/:event_id/event_generators/new
  def new
    @event = Event.find(params[:event_id])
    @event_generator = EventGenerator.new
  end

  # ??? /event/:event_id/event_generators
  def create
    @event = Event.find(params[:event_id])

    @event_generator = EventGenerator.new(event_generator_params)
    @event_generator.event_seed = @event.event_seeds.last # TODO: THIS IS WRONG!!!! TEMPORARY

    old_event_generator = @event.event_generators.last # TODO: SHOULD BE BY DATE, NOT CREATED DATE
    if old_event_generator
      if old_event_generator.end_date
        if old_event_generator.end_date > @event_generator.start_date
          @event_generator.errors.add(:start_date, "can't be before the end date of the previous period")
          render :new
          return
        end
      else
        old_event_generator.end_date = @event_generator.start_date
        old_event_generator.save!
      end
    end

    @event_generator.save!
    redirect_to event_path(@event)
  end


  private def event_generator_params
    params.require(:event_generator).permit(
      :start_date,
      :frequency
    )
  end
end
