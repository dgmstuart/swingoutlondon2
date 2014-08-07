class AddEventIdToEventSeeds < ActiveRecord::Migration
  def change
    add_column :event_seeds, :event_id, :integer
  end
end
