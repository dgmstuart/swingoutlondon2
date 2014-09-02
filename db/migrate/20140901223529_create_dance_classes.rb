class CreateDanceClasses < ActiveRecord::Migration
  def change
    create_table :dance_classes do |t|
      t.integer :day, null: false

      t.timestamps
    end
  end
end
