class AddStartDateToEventGenerators < ActiveRecord::Migration
  def change
    add_column :event_generators, :start_date, :date, null: false
  end
end
