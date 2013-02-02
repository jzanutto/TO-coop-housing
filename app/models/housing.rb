class Housing < ActiveRecord::Base
  attr_accessible :Lat, :Location, :Long, :Postal, :Price
  validates :Lat, :presence=>true
  validates :Long, :presence=>true
end
