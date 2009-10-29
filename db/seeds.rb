# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

admin = User.create([{:login => 'Galen', :password => 'pass', :admin_level => 3},{:name => 'User', :password => 'pass', :admin_level => 1}])
first_prompt = Prompt.create([{:hero => 'Pirate with a Wooden Leg', :villain => 'Woodpecker', :goal => 'Float to Shore', :use_on => '20091017'}])