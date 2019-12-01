class User < ActiveRecord::Base
  acts_as_token_authenticatable
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :encryptable

  # attr_accessible :login, :email, :password, :password_confirmation, :profile, :website, :send_comments, :send_stories, :send_followings

  before_create :ensure_login, if: Proc.new {|u| u.login.blank? }

  acts_as_tagger
  acts_as_voter
  has_karma :stories, :as => :user, :weight => 1
  has_karma :comments, :as => :user, :weight => 1
  has_karma :prompts, :as => :user, :weight => 1

  # extend FriendlyId
  # friendly_id :login, use: :slugged, :reserved_words => ["recent", "new", "featured", "active", "popular", "top"]
  def to_param
    "#{id}-#{login.parameterize}" rescue id
  end

  has_many :followings
  has_many :writers, :through => :followings
  has_many :inverse_followings, :class_name => "Following", :foreign_key => "writer_id"
  has_many :followers, :through => :inverse_followings, :source => :user

  has_many :stories
  has_many :comments
  has_many :prompts

  def email_address
    email
  end

  def self.find_by_login_or_email(login)
    User.find_by_login(login) || User.find_by_email(login)
  end

  def is_admin?
    admin_level > 1
  end

  def can_edit?
    is_admin? || reputation >= 5
  end

  def ensure_login
    self.login = email.split("@").first
  end

  def self.dedupe
    duped_users = User.select(:email).group(:email).having("count(*) > 1")
    a = duped_users.collect(&:email).compact
    a.each do |ea|
      puts "Email is: #{ea}"
      dupes_for_user = User.where(email: ea).order("reputation DESC")
      keep = dupes_for_user.first
      users_to_be_combined = dupes_for_user.where.not(id: keep.id)

      users_to_be_combined.each do |user| 
        kr = keep.reputation || 0
        ur = user.reputation || 0
        new_reputation = kr + ur
        user.stories.update_all(user_id: keep.id)
        user.comments.update_all(user_id: keep.id)
        user.prompts.update_all(user_id: keep.id)
        user.followings.update_all(user_id: keep.id)
        user.inverse_followings.update_all(writer_id: keep.id)
        keep.update_attribute :reputation, new_reputation
      end

      users_to_be_combined.destroy_all
    end
  end

end