class Story < ActiveRecord::Base

  CC_OPTIONS = ["Creative Commons Attribution 3.0","Creative Commons Attribution-NoDerivs 3.0", "Creative Commons Attribution-NonCommerical-NoDerivs 3.0", "Creative Commons AttributionNonCommerical 3.0","Creative Commons Attribution-NonCommerical-ShareAlike 3.0", "Creative Commons Attribution-ShareAlike 3.0","Public Domain"]

  #acts_as_taggable
  acts_as_taggable_on :tags
  acts_as_taggable_on :genres
  acts_as_taggable_on :emotions
  acts_as_voteable

  # extend FriendlyId
  # friendly_id :title, use: :slugged, :reserved_words => ["recent", "featured", "active", "popular", "top", "genres","emotions","tags"]

  def to_param
    "#{id}-#{title.parameterize}"
  end

  def should_generate_new_friendly_id?
    new_record?
  end

  belongs_to :user, :counter_cache => true
  belongs_to :prompt, :counter_cache => true
  has_one :contest
  has_many :comments

  # Named Scopes
  scope :active, lambda {where("stories.active = ?", true)}
  scope :usable, -> { active }
  scope :inactive, lambda {where("stories.active = ?", false)}
  scope :recent, lambda {|timeframe|
        active.where('stories.created_at > ?', timeframe.to_datetime) }
  scope :popular, lambda { where('(comments_count >= ? or votes_count >= ?)', 0, 0).order('counter DESC, votes_count DESC, updated_at ASC') }
  scope :top, lambda { where('votes_count > ?', 0).order('votes_count DESC')}
  scope :commented, lambda { where('(comments_count >= ?)', 0).order('comments_count DESC, votes_count DESC, counter DESC, updated_at ASC') }
  scope :featured, lambda {where('featured = ?', true)}
  scope :by_popularity, lambda {order('counter ASC')}

  # Filters
  scope :by_date, -> {order("stories.created_at DESC")}

  # Next and Previous links
  scope :next, lambda { |p| active.where("id > ?", p.id).limit(1).order("id")}
  scope :previous, lambda { |p| active.where("id < ?", p.id).limit(1).order("id DESC")}

  scope :next_featured, lambda { |p| active.where("id > ? AND featured = ?", p.id, true).limit(1).order("id")}
  scope :previous_featured, lambda { |p| active.where("id < ? AND featured = ?", p.id, true).limit(1).order("id DESC")}

  scope :with_unseen_comments_for_user, lambda { |user|
       select("DISTINCT stories.*").
       joins("INNER JOIN comments ON comments.story_id = stories.id INNER JOIN comments others_comments ON others_comments.story_id = stories.id INNER JOIN users ON comments.user_id = users.id ").
       active.where("users.id = ? AND (others_comments.created_at > comments.created_at AND others_comments.created_at > users.updated_at)", user)

  }

  scope :with_comments_for_user, lambda { |user|
       select("DISTINCT stories.*").
       joins("INNER JOIN comments ON comments.story_id = stories.id INNER JOIN comments others_comments ON others_comments.story_id = stories.id INNER JOIN users ON comments.user_id = users.id").
       active.where("users.id = ? AND (others_comments.created_at > comments.created_at OR others_comments.created_at > users.last_login_at OR stories.user_id = ?)", user, user)


  }

  scope :new_comments_for_user_stories, lambda {|user|
      select("DISTINCT stories.*").
      joins("INNER JOIN comments others_comments ON others_comments.story_id = stories.id INNER JOIN users ON stories.user_id = users.id ").
      active.where("stories.user_id = ? AND (others_comments.created_at > users.last_login_at)", user)

  }

  scope :all_comments_for_user_stories, lambda {|user|
      select("DISTINCT stories.*").
      joins("INNER JOIN comments others_comments ON others_comments.story_id = stories.id").
      active.where("stories.user_id = ?", user)

  }

  # Validation
  validates_presence_of   :title, :message => "Without a title, your story is invisible!"
  validates_presence_of   :description, :message => "Perhaps you should write a story."
  validates_presence_of   :license, :message => "What license?"
  validates_presence_of   :prompt_id, :message => "Prompt is necessary."

  def cc_licence_image_url
    # method to get image url for display on story
  end

  def safe_title
    title.present? ? title : "Untitled Story"
  end

  def truncated_description
    description.truncate_words(100)
  end

  def joined_tags
    tags.join(", ")
  end

  def self.random
    active.where(id: Story.active.pluck(:id).sample).first
  end

end