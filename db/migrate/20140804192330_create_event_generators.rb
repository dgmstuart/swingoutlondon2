class CreateEventGenerators < ActiveRecord::Migration
  def change
    create_table :event_generators do |t|
      t.string :url
      t.integer :event_id

      t.timestamps
    end
  end
end
