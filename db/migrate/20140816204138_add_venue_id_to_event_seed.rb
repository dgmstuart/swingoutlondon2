class AddVenueIdToEventSeed < ActiveRecord::Migration
  def change
    add_column :event_seeds, :venue_id, :integer, null: false
  end
end
