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
  #   # TODO: should I be using strong parameters here?
  #   event_instance = EventInstance.find(params[:id])

  #   # update_attribute skips validations, but that's probably what we want here,
  #   # since we want to mark it as cancelled, even if (for some reason) it was already invalid
  #   event_instance.update_attribute(:cancelled, params[:event_instance][:cancelled])

  #   redirect_to :back
    redirect_to event_path(@event_generator.event)
  end
end
