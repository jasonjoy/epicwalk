class Journey < ActiveRecord::Base

	geocoded_by :start_addr
	after_validation :geocode
	geocoded_by :dest_addr
	after_validation :geocode

end
