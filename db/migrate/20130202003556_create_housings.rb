class CreateHousings < ActiveRecord::Migration
  def up
    create_table :housings do |t|
      t.string :Location
      t.float :Lat
      t.float :Long
      t.string :Postal
      t.float :Price

      t.timestamps
    end
  end
end
