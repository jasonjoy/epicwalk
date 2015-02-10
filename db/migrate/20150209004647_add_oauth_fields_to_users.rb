class AddOauthFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :oauth_secret, :string
  end
end
