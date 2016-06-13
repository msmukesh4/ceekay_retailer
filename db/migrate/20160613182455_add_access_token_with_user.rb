class AddAccessTokenWithUser < ActiveRecord::Migration
  	def change
  		add_column :users, :access_token, :string, :limit => 20
  	end
end
