class CreateEventSeeds < ActiveRecord::Migration
  def change
    create_table :event_seeds do |t|
      t.string :url

      t.timestamps
    end
  end
end
