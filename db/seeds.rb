# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

User.create([{:login => 'Galen', :password => 'pass', :admin_level => 3}])
User.create([{:login => 'User', :crypted_password => '476aac1e2b50cff5651b70de3bbdbba35301dd0215625993201f5e086cc36eb6cf9ae549e75b7a1c4324687337045d9a6728d5ecc56261965bccf6dd710eac22', :password_salt => '6ZUPqL4ig8fxAz1zfMSd', :admin_level => 1}])
Prompt.create([{:hero => 'Pirate with a Wooden Leg', :villain => 'Woodpecker', :goal => 'Float to Shore', :use_on => '20091017'}])
