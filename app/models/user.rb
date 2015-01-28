class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :journeys

  def calculate_distance
	p = fitbit_data.activity_on_date_range 'distance','2014-12-01','2014-12-31'
	dist = p["activities-distance"]

	collection = dist.collect do |day|
	  day["value"].to_f

	
  	end

  	collection.sum
  end

end
