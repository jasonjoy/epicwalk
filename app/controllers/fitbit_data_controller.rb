class FitbitDataController < ApplicationController

	def create
		current_user.fitbit_data.create
	end



end
