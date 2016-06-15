# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


User.delete_all
User.create :email => 'super@user.com', :password =>'1x1rWngoyz1LBmtM4qJvCA==\n', :access_token => '12345678900987654321',:is_first_logged_in => true, :is_admin => true ,:created_at => DateTime.now.utc, :updated_at => DateTime.now.utc
User.create :email => 'admin@user.com', :password =>'1x1rWngoyz1LBmtM4qJvCA==\n', :access_token => '12345678900987654321',:is_first_logged_in => false, :is_admin => true ,:created_at => DateTime.now.utc, :updated_at => DateTime.now.utc