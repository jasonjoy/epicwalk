class JourneysAddDistance < ActiveRecord::Migration
  def change 
  	  add_column :journeys, :total_distance_in_meters, :integer
  	  remove_column :journeys, :waypoints
  end
end
