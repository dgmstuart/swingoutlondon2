class AddEndDateToEventGenerators < ActiveRecord::Migration
  def change
    add_column :event_generators, :end_date, :date
  end
end
