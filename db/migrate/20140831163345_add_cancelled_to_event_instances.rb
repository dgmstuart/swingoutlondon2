class AddCancelledToEventInstances < ActiveRecord::Migration
  def change
    add_column :event_instances, :cancelled, :boolean, default: false
  end
end
