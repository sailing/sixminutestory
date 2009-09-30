class User < ActiveRecord::Base
  acts_as_authentic
  acts_as_tagger
  acts_as_voter
  
  has_many :stories
  has_many :comments
  
  validates_format_of :website, :with => /https?:\/\/.*/i, :message => "Please start URLs with http:// or https://", :allow_blank => true
    
end