class User < ActiveRecord::Base
  acts_as_authentic
  acts_as_tagger
  acts_as_voter
  
  has_many :stories
  has_many :comments
  
  def self.find_by_login_or_email(login)
    User.find_by_login(login) || User.find_by_email_address(login)
  end
      
end