class ChangeEventIdToEventSeedIdInEventGenerators < ActiveRecord::Migration
  def change
    rename_column :event_generators, :event_id, :event_seed_id
  end
end
