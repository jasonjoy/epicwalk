class FitbitAuthController < ApplicationController
	def authorize
		config = {:consumer_key => ENV["FITBIT_CONSUMER_KEY"], :consumer_secret => ENV["FITBIT_CONSUMER_SECRET"]}
    #	@client ||= Fitgem::Client.new(

    #	if user_signed_in?
    #		config = {
    #			:consumer_key => ENV["FITBIT_CONSUMER_KEY"],
    #			:consumer_secret => ENV["FITBIT_CONSUMER_SECRET"],
    #			:token => current_user.oauth_token,
    #			:secret => current_user.oauth_secret,
    #			:user_id => current_user.uid
    ##	else
  	#	config = {
    #			:consumer_secret => ENV["FITBIT_CONSUMER_SECRET"]
    #		}
    #	end

	#	raise config.inspect
		client = Fitgem::Client.new(config)

		request_token = client.request_token
		token = request_token.token
	#	secret = request_token.secret
	#	user_id = client.user_info['user']['encodedId']
		session[:token]= request_token.token
		session[:secret]= request_token.secret
		redirect_to "http://www.fitbit.com/oauth/authorize?oauth_token=#{token}"
	end

	def confirm
		config = {:consumer_key => ENV["FITBIT_CONSUMER_KEY"], :consumer_secret => ENV["FITBIT_CONSUMER_SECRET"]}
		client = Fitgem::Client.new(config)
  
		access_token = client.authorize(session[:token], session[:secret], {:oauth_verifier => params[:oauth_verifier]})
		user_id = client.user_info['user']['encodedId']

		current_user.update_attribute(:oauth_token, access_token.token)
		current_user.update_attribute(:oauth_secret, access_token.secret)
		current_user.update_attribute(:uid, user_id)
		redirect_to root_path
	end

end
