class AlterJourneysAddUserIdColumn < ActiveRecord::Migration
  def change
  	add_column :journeys, :user_id, :integer
  	add_index :journeys, :user_id
  end
end
