class CancellationsController < ApplicationController
  before_action :authenticate_user!

  # PATCH /cancellations/:id
  def update
    # TODO: should I be using strong parameters here?
    event_instance = EventInstance.find(params[:id])

    # update_attribute skips validations, but that's probably what we want here,
    # since we want to mark it as cancelled, even if (for some reason) it was already invalid
    event_instance.update_attribute(:cancelled, params[:event_instance][:cancelled])

    redirect_to :back
  end
end
