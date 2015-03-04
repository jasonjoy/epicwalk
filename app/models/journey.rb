class Journey < ActiveRecord::Base
	belongs_to :user
	has_many :daily_legs
#	serialize :waypoints
	def dist_so_far
		self.user.calculate_distance(self.start_date, Time.now)[:sum]
	end
end
