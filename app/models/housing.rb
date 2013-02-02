class Housing < ActiveRecord::Base
  attr_accessible :lat, :long, :location, :postal, :price
  validates :lat, :presence=>true
  validates :long, :presence=>true
end
