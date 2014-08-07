class AddFrequencyToEventGenerator < ActiveRecord::Migration
  def change
    add_column :event_generators, :frequency, :integer
    remove_column :event_generators, :url
    change_column :event_generators, :event_id, :integer, null: false
  end
end
