class JourneysController < ApplicationController
	before_action :authenticate_user!, :only => [:new, :create]

	def index
		@journeys = Journey.all
	end

	def new
		@journey = Journey.new
	end

	def create
		current_user.journeys.create(journey_params)
		redirect_to root_path
	end

	def show
		@journey = Journey.find(params[:id])
	end

	def edit
		@journey = Journey.find(params[:id])
	end

	def update
		@journey = Journey.find(params[:id])
		@journey.update_attributes(journey_params)
		redirect_to root_path
	end

	def destroy
		@journey = Journey.find(params[:id])
		@journey.destroy
		redirect_to root_path
	end

	private

	def journey_params
		params.require(:journey).permit(:name, :start_addr, :dest_addr, :start_date)
	end

end
