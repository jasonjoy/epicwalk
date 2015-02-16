class AddOauthInfoToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :oauth_secret, :string
	add_column :users, :uid, :string
  end
end
