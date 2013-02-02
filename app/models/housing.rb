class Housing < ActiveRecord::Base
  attr_accessible :lat, :location, :long, :postal, :price
  validates :lat, :presence=>true
  validates :long, :presence=>true
end
