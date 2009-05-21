class User < ActiveRecord::Base
  acts_as_authentic
  acts_as_tagger
  acts_as_voter
  
  has_many :shares
  has_many :comments
  
end