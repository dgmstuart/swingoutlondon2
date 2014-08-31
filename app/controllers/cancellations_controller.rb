class CancellationsController < ApplicationController
  before_action :authenticate_user!

  # PATCH /cancellations/:id
  def update
    # TODO: should I be using strong parameters here?
    event_instance = EventInstance.find(params[:id])
    event_instance.update(cancelled: params[:event_instance][:cancelled])

    # TODO: case where update fails

    redirect_to :back
  end
end