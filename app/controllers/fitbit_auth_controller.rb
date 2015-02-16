class FitbitAuthController < ApplicationController
	def authorize
	  config = {'consumer_key' => ENV["FITBIT_CONSUMER_KEY"], 'consumer_secret' => ENV["FITBIT_CONSUMER_SECRET"]}
	  #raise config.inspect
	  client = Fitgem::Client.new(config)

	  request_token = client.request_token
	  token = request_token.token
	  secret = request_token.secret

	  redirect_to "http://www.fitbit.com/oauth/authorize?oauth_token=#{token}"
	end

	def confirm
		current_user.update_attribute(:oauth_token,params[:oauth_token])
		redirect_to root_path
	end

end
