class RemoveFieldsFromEvents < ActiveRecord::Migration
  def change
    Event.destroy_all
    remove_column :events, :url, :string
    remove_column :events, :frequency, :integer
    remove_column :events, :date, :date
    add_column :events, :name, :string, null: false
    add_timestamps :events
  end
end
