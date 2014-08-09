class DatesController < ApplicationController
  # GET /events/:id/dates/new
  def new
    @event_generator = EventGenerator.new
  end

  # POST /events/:id/dates
  def create
    # TODO: needs strong params here?
    event = Event.find(params[:event_id])
    # TODO - pick the right seed/move this logic into a model
    event_seed = event.event_seeds.last
    @event_generator = EventGenerator.new(event_generator_params)
    @event_generator.event_seed = event_seed
    @event_generator.frequency = 0
    if @event_generator.save
      # TODO: FLASH?
      # TODO: Don't generate straight away?
      @event_generator.generate
      redirect_to @event_generator.event
    else
      render :new
    end
  end

private

  def event_generator_params
    params.require(:event_generator).permit(
      :start_date
    )
  end
end