class User < ActiveRecord::Base
  
  acts_as_authentic do |c|
    c.maintain_sessions = false
    c.perishable_token_valid_for = 24.hours
    c.logged_in_timeout = 30.minutes
  end
  acts_as_tagger
  acts_as_voter
  
  #has_friendly_id :login
    
  has_many :followings
  has_many :writers, :through => :followings
  has_many :inverse_followings, :class_name => "Following", :foreign_key => "writer_id"
  has_many :followers, :through => :inverse_followings, :source => :user
  
  has_many :stories
  has_many :comments

  def login
        if login.present? 
          login.downcase
        else 
          self.login = facebook_session.user.name
        end
  end
  
  def self.find_by_login_or_email(login)
    User.find_by_login(login) || User.find_by_email_address(login)
  end
  
  def is_admin?
    if self.admin_level > 1
     return true
    end
  end
 
end