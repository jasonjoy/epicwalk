class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :journeys

  def linked?
    oauth_token.present? && oauth_secret.present?
  end

  def fitbit_data
    raise "Account is not linked with a Fitbit account" unless linked?
    @client ||= Fitgem::Client.new(
                :consumer_key => ENV["FITBIT_CONSUMER_KEY"],
                :consumer_secret => ENV["FITBIT_CONSUMER_SECRET"],
                :token => oauth_token,
                :secret => oauth_secret,
                :user_id => uid
              )
  end

  def has_fitbit_data?
    !@client.nil?
  end


  def calculate_distance(start_date, end_date)

	# Write the whole oauth token set back to the config file
	# File.open(".fitgem.yml", "w") {|f| f.write(config.to_yaml) }
  
  	# ============================================================
	# Add Fitgem API calls on the client object below this line
  
	p = fitbit_data.activity_on_date_range 'distance',start_date.strftime('%Y-%m-%d'),end_date.strftime('%Y-%m-%d')
	dist = p["activities-distance"]

	collection = dist.collect do |day|
	  day["value"].to_f
	end
	value = {
		:collection => collection, :sum => collection.sum
	}

  end

end
