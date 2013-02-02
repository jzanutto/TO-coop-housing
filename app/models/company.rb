class Company < ActiveRecord::Base
  attr_accessible :Lat, :Location, :Long, :Name, :Postal
  validates :Name, :presence=>true
  validates :Lat, :presence=>true
  validates :Long, :presence=>true
end
