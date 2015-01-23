class CreateJourneys < ActiveRecord::Migration
  def change
    create_table :journeys do |t|

      t.string :name
      t.string :start_addr
      t.string :dest_addr
      t.date   :start_date

      t.timestamps
    end
  end
end
