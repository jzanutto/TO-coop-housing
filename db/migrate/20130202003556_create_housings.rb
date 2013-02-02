class CreateHousings < ActiveRecord::Migration
  def change
    create_table :housings do |t|
      t.text :Location
      t.real :Lat
      t.real :Long
      t.text :Postal
      t.real :Price

      t.timestamps
    end
  end
end
