class CreateDailyLegs < ActiveRecord::Migration
  def change
    create_table :daily_legs do |t|
      t.datetime	:date
      t.float		:distance
      t.string		:start_addr
      t.float		:start_lat
      t.float		:start_long
      t.string		:end_addr
      t.float		:end_lat
      t.float		:end_long

      t.timestamps
    end
  end
end
