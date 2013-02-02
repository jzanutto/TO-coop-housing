class Company < ActiveRecord::Base
  attr_accessible :lat, :location, :long, :name, :postal
  validates :name, :presence=>true
  validates :lat, :presence=>true
  validates :long, :presence=>true
  
  def self.find_by_name(name)
    company = Company.where(:name=>name).to_json
    return company
  end
end
