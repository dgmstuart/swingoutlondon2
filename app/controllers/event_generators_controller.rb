class EventGeneratorsController < ApplicationController
  # TODO: Authenticate! - put in specs
  # before_action :authenticate_user!

  # GET /event_generators/:id/edit
  def edit
    @event_generator = EventGenerator.find(params[:id])
  end

  # PATCH /event_generators/:id
  def update
    @event_generator = EventGenerator.find(params[:id])

    event_generator_params = params.require(:event_generator).permit(:end_date)
    # TODO - failure case

    @event_generator.update!(event_generator_params)

    redirect_to event_path(@event_generator.event)
  end
end
