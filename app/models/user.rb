class User < ActiveRecord::Base
  acts_as_authentic
  acts_as_tagger
  acts_as_voter
  
  has_many :followings
  has_many :writers, :through => :followings
  has_many :inverse_followings, :class_name => "Following", :foreign_key => "writer_id"
  has_many :followers, :through => :inverse_followings, :source => :user
  
  has_many :stories
  has_many :comments
  
  has_one :preference 
  
  def self.find_by_login_or_email(login)
    User.find_by_login(login) || User.find_by_email_address(login)
  end
  
  def is_admin?
    if self.admin_level > 1
     return true
    end
  end
  
      
end