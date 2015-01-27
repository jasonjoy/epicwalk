class Location < ActiveRecord::Base
	belongs_to :journey
	geocoded_by :address
	after_validation :geocode
end
