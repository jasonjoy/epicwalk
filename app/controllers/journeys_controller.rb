class JourneysController < ApplicationController
	def index
		@journeys = Journey.all
	end

	def new
		@journey = Journey.new
	end

	def create
		Journey.create(journey_params)
		redirect_to root_path
	end

	def show
		@journey = Journey.find(params[:id])
	end

	private

	def journey_params
		params.require(:journey).permit(:name, :start_addr, :dest_addr, :start_date)
	end

end
