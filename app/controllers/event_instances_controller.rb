class EventInstancesController < ApplicationController
  # GET /event_instances
  def index
    @event_instances = EventInstance.all
  end
end