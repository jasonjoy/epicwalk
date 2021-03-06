class JourneysController < ApplicationController
	before_action :authenticate_user!, :only => [:new, :create]

	def index
		@journeys = Journey.all.page(params[:page]).per(7)
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
		respond_to do |format|
			format.html do
				redirect_to journey_path
			end
			format.json do
				render :json => @journey
			end
		end
	end

	def destroy
		@journey = Journey.find(params[:id])
		@journey.destroy
		redirect_to root_path
	end

	private

	def journey_params
		params.require(:journey).permit(:name, :start_addr, :dest_addr, :start_date, :total_distance_in_meters)
	end

end
