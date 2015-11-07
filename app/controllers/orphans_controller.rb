class OrphansController < ApplicationController
  before_action :authenticate_user!

  # GET /events/:event_id/orphans
  def index
    @orphans = EventInstance.find(params.require(:orphans))
  end

  # DELETE /events/:event_id/destroy_multiple
  def destroy_multiple
    form = OrphansForm.new(params)
    result = DestroyOrphans.new(form).call
    flash[:info] = "Orphaned instances deleted: #{result.dates}"
    redirect_to controller: :events, action: :show, id: params.require(:event_id)
  end
end

class OrphansForm
  attr_reader :orphan_ids
  def initialize(params)
    @orphan_ids = params[:orphans] || []
  end
end

# Service object
class DestroyOrphans
  def initialize(form)
    @orphan_ids = form.orphan_ids
  end

  def call
    destroyed_orphans = orphans.destroy_all
    DestroyedOrphans.new(destroyed_orphans)
  end

  private def orphans
    EventInstance.where(id: @orphan_ids)
  end
end

# Presenter
class DestroyedOrphans
  def initialize(orphans)
    @orphans = Array(orphans)
  end

  def dates
    @orphans.map { |o| I18n.l(o.date) }.join(', ')
  end
end
