class CreateCompanies < ActiveRecord::Migration
  def up
    create_table :companies do |t|
      t.string :name
      t.string :location
      t.float :lat
      t.float :long
      t.string :postal

      t.timestamps
    end
  end
end
