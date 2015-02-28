class AlterJourneyAddWaypoints < ActiveRecord::Migration
  def change
  	add_column :journeys, :waypoints, :text
  end
end
