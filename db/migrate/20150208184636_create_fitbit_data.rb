class CreateFitbitData < ActiveRecord::Migration
  def change
    create_table :fitbit_data do |t|
      t.datetime :actvity_date
      t.float    :distance

      t.timestamps
    end
  end
end
