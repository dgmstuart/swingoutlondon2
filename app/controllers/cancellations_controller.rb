class CancellationsController < ApplicationController
  # before_action :authenticate_user!

  # PATCH /cancellations/:id
  def update
    event_instance = EventInstance.find(params[:id])
    event_instance.update(cancelled: true)

    # TODO: case where update fails
    redirect_to event_path(event_instance.event)
  end
end