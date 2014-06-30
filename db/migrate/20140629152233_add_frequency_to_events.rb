class AddFrequencyToEvents < ActiveRecord::Migration
  def change
    add_column :events, :frequency, :integer, null: false
  end
end
