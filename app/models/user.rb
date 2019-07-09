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
  has_many :prompts

  def will_save_change_to_email?
    false
  end

  def self.find_by_login_or_email(login)
    User.find_by_login(login) || User.find_by_email_address(login)
  end

  def is_admin?
    admin_level > 1
  end

  def can_edit?
    is_admin? || reputation >= 5
  end

  def self.dedupe
    u = User.select(:email_address).group(:email_address).having("count(*) > 1")
    a = u.map(&:email_address)
    a.each do |ea| 
      u = User.where(email_address: ea).order("reputation DESC")
      keep = u.first
      u = u.where.not(id: keep.id)

      u.each do |user| 
        kr = keep.reputation || 0
        ur = user.reputation || 0
        new_reputation = kr + ur
        user.stories.update_all(user_id: keep.id)
        user.comments.update_all(user_id: keep.id)
        user.prompts.update_all(user_id: keep.id)
        user.followings.update_all(user_id: keep.id)
        user.inverse_followings.update_all(writer_id: keep.id)
        user.votes.update_all(voter_id: keep.id)
        keep.update_attributes reputation: new_reputation
      end

      u.destroy
    end
  end

end