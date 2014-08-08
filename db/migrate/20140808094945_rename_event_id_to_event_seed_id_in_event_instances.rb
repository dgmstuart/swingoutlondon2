class RenameEventIdToEventSeedIdInEventInstances < ActiveRecord::Migration
  def change
    rename_column :event_instances, :event_id, :event_seed_id
  end
end
