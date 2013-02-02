class CreateHousings < ActiveRecord::Migration
  def up
    create_table :housings do |t|
      t.string :location
      t.float :lat
      t.float :long
      t.string :postal
      t.float :price

      t.timestamps
    end
  end
end
