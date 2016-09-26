class AddNameToEventInstance < ActiveRecord::Migration[5.0]
  def change
    add_column :event_instances, :name, :string, limit: 255
  end
end
