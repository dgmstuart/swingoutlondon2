class EventInstancesController < ApplicationController
  # GET /event_instances
  def index
    @event_instances = EventInstance.all.includes(:event_seed, :event)
  end

  # DELETE /event_instances/:id
  def destroy
    event_instance = EventInstance.find(params[:id])
    event_instance.destroy

    redirect_to :back
  end
end