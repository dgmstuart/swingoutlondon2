class AddVenueIdToEventInstances < ActiveRecord::Migration
  def change
    add_column :event_instances, :venue_id, :integer, null: true
  end
end
