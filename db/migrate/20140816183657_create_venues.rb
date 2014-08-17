class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :name, null: false
      t.text :address, null: false
      t.string :postcode, null: false
      t.string :url, null: false

      t.timestamps
    end
  end
end
