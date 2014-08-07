class AddUrlToEventInstances < ActiveRecord::Migration
  def change
    add_column :event_instances, :url, :string
  end
end
