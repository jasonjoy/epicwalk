class JourneysController < ApplicationController
	def index
		@journeys = Journey.all
	end

	def new
		@journey = Journey.new
	end

end
