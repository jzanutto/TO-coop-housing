class Housing < ActiveRecord::Base
  attr_accessible :Lat, :Location, :Long, :Postal, :Price
end
