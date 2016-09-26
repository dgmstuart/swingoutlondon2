class MoveNameFromEventToEventSeed < ActiveRecord::Migration[5.0]
  def self.up
    add_column :event_seeds, :name, :string, limit: 255
    execute 'UPDATE event_seeds s SET name = (SELECT e.name FROM events e WHERE e.id = s.event_id);'
    change_column_null :event_seeds, :name, false
    remove_column :events, :name
  end

  def self.down
    add_column :events, :name, :string, limit: 255
    execute 'UPDATE events e SET name = (SELECT s.name FROM event_seeds s WHERE s.event_id = e.id);'
    change_column_null :events, :name, false
    remove_column :event_seeds, :name
  end
end
