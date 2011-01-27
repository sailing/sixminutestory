class User < ActiveRecord::Base
  
  acts_as_authentic do |c|
    c.maintain_sessions = false
    c.perishable_token_valid_for = 24.hours
    c.logged_in_timeout = 30.minutes
    
  # validations
    c.merge_validates_length_of_password_field_options :allow_blank => true
  
  # enable Authlogic_RPX account merging (false by default, if this statement is not present)
    c.account_merge_enabled true
    
  # set Authlogic_RPX account mapping mode
    c.account_mapping_mode :internal
    
    
  end
  acts_as_tagger
  acts_as_voter
  has_karma :stories, :as => :user, :weight => 1
  
  has_friendly_id :login, :use_slug => true,:reserved_words => ["new", "featured"]
    
  has_many :followings
  has_many :writers, :through => :followings
  has_many :inverse_followings, :class_name => "Following", :foreign_key => "writer_id"
  has_many :followers, :through => :inverse_followings, :source => :user
  
  has_many :stories
  has_many :comments


  
  def self.find_by_login_or_email(login)
    User.find_by_login(login) || User.find_by_email_address(login)
  end
  
  def is_admin?
    if self.admin_level > 1
     return true
    end
  end
 
end