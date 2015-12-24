class RenameEventGeneratorsToEventPeriods < ActiveRecord::Migration
  def change
    rename_table :event_generators, :event_periods
  end
end
