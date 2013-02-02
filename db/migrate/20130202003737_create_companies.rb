class CreateCompanies < ActiveRecord::Migration
  def up
    create_table :companies do |t|
      t.string :Name
      t.string :Location
      t.float :Lat
      t.float :Long
      t.string :Postal

      t.timestamps
    end
  end
end
