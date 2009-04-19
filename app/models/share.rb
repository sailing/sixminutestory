class Share < ActiveRecord::Base
  belongs_to :user
  # Ferret full text search
 # acts_as_ferret :fields =>{:title => {:store => true},:description => {:store => true}}
  
  end
