# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

User.create(:login => 'Galen', :password => 'pass', :password_confirmation => 'pass', :email_address => 'galen@sixminutestory.com',:admin_level => 3)
User.create(:login => 'User', :password => 'pass', :password_confirmation => 'pass', :email_address => 'user@sixminutestory.com', :admin_level => 1)
Prompt.create([{:hero => 'Pirate with a Wooden Leg', :villain => 'Woodpecker', :goal => 'Float to Shore', :use_on => '20091017'}])
