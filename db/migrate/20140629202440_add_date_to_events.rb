class AddDateToEvents < ActiveRecord::Migration
  def change
    add_column :events, :date, :date, null: false
  end
end
