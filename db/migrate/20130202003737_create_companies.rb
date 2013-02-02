class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.text :Name
      t.text :Location
      t.real :Lat
      t.real :Long
      t.text :Postal

      t.timestamps
    end
  end
end
