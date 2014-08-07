class CreateEventInstances < ActiveRecord::Migration
  def change
    create_table :event_instances do |t|
      t.date :date, null: false
      t.integer :event_id, null: false

      t.timestamps
    end
  end
end
