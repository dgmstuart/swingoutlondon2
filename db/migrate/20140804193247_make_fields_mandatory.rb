class MakeFieldsMandatory < ActiveRecord::Migration
  def change
    change_column :event_generators, :frequency, :integer, null: false
    change_column :event_seeds, :event_id, :integer, null: false
  end
end
