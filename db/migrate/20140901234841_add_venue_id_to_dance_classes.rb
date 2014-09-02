class AddVenueIdToDanceClasses < ActiveRecord::Migration
  def change
    add_column :dance_classes, :venue_id, :integer, null: false
  end
end
