class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  # acts_as_authentic do |c|
  #   c.maintain_sessions = true
  #   c.perishable_token_valid_for = 24.hours
  #   c.logged_in_timeout = 30.minutes

  # # validations
  #   c.merge_validates_length_of_password_field_options :allow_blank => true

  # # enable Authlogic_RPX account merging (false by default, if this statement is not present)
  #   c.account_merge_enabled true

  # # set Authlogic_RPX account mapping mode
  #   c.account_mapping_mode :internal


  # end

  # attr_accessible :login, :email_address, :password, :password_confirmation, :profile, :website, :send_comments, :send_stories, :send_followings

  acts_as_tagger
  acts_as_voter
  has_karma :stories, :as => :user, :weight => 1
  has_karma :comments, :as => :user, :weight => 1
  has_karma :prompts, :as => :user, :weight => 1

  extend FriendlyId
  friendly_id :login, use: :slugged, :reserved_words => ["recent", "new", "featured", "active", "popular", "top"]

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
    admin_level > 1
  end

  def can_edit?
    is_admin? || reputation >= 5
  end

end