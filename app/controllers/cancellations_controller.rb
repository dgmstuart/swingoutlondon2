class CancellationsController < ApplicationController
  before_action :authenticate_user!

  # POST /cancellations/:id
  def create
    # TODO: should I be using strong parameters here?
    event_instance = EventInstance.find(params[:event_instance][:id])

    # update_attribute skips validations, but that's probably what we want here,
    # since we want to mark it as cancelled, even if (for some reason) it was already invalid
    event_instance.update_attribute(:cancelled, true) # rubocop:disable Rails/SkipsModelValidations

    redirect_back(fallback_location: root_path)
  end

  # DELETE /cancellations/:id
  def destroy
    # TODO: should I be using strong parameters here?
    event_instance = EventInstance.find(params[:id])

    # update_attribute skips validations, but that's probably what we want here,
    # since we want to mark it as cancelled, even if (for some reason) it was already invalid
    event_instance.update_attribute(:cancelled, false) # rubocop:disable Rails/SkipsModelValidations

    redirect_back(fallback_location: root_path)
  end
end
