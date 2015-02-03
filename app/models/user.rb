class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :journeys

  def calculate_distance
	config = {:consumer_key => ENV["FITBIT_CONSUMER_KEY"], :consumer_secret => ENV["FITBIT_CONSUMER_SECRET"]}
	client = Fitgem::Client.new(config)

	begin
	    access_token = client.authorize(token, secret, { :oauth_verifier => verifier })
	  rescue Exception => e
	    puts "Error: Could not authorize Fitgem::Client with supplied oauth verifier"
	    exit
	  end

	  puts 'Verifier is: '+verifier
	  puts "Token is:    "+access_token.token
	  puts "Secret is:   "+access_token.secret

	  user_id = client.user_info['user']['encodedId']
	  puts "Current User is: "+user_id

	  config[:oauth].merge!(:token => access_token.token, :secret => access_token.secret, :user_id => user_id)

	  # Write the whole oauth token set back to the config file
	  File.open(".fitgem.yml", "w") {|f| f.write(config.to_yaml) }
	end

	# ============================================================
	# Add Fitgem API calls on the client object below this line

	p = client.activity_on_date_range 'distance','2014-12-01','2014-12-31'
	dist = p["activities-distance"]

	collection = dist.collect do |day|
	  day["value"].to_f
	end

	# Puts each day
	puts collection.inspect
  end

end
