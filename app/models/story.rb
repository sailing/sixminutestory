class Story < ActiveRecord::Base
  #acts_as_taggable  
  acts_as_taggable_on :tags
  acts_as_taggable_on :genres
  acts_as_taggable_on :emotions
  acts_as_voteable
  
  has_friendly_id :title, :use_slug => true, :reserved_words => ["recent", "featured", "active", "popular", "top", "genres","emotions","tags"]
  
  belongs_to :user, :counter_cache => true
  belongs_to :prompt, :counter_cache => true
  has_one :contest
  has_many :comments
  
  
  # Named Scopes
  scope :active, :conditions => {:active => true}
  scope :inactive, :conditions => {:active => false}
  scope :recent, lambda { { :conditions => ['created_at > ?', 1.week.ago], :order => 'created_at DESC' } }
  scope :popular, lambda { { :conditions => ['(comments_count >= ? or rating >= ?) AND created_at > ?', 0, 0, 1.month.ago], :order => 'counter DESC, rating DESC, updated_at ASC' } }
  scope :commented, lambda { { :conditions => ['(comments_count >= ?) AND created_at > ?', 1, 1.week.ago], :order => 'comments_count DESC, rating DESC, counter DESC, updated_at ASC' } }
  scope :top, lambda { { :conditions => ['rating > 0'], :order => 'rating DESC, counter ASC' } }
  scope :featured, :limit => 1, :conditions => ['featured = ? AND created_at > ?', true, 1.month.ago], :order => 'counter ASC'
  
  # Filters
  scope :by_date, :order => "stories.created_at DESC"
  
  # Next and Previous links
  scope :next, lambda { |p| {:conditions => ["id > ? AND active = ?", p.id, true], :limit => 1, :order => "id"} }
  scope :previous, lambda { |p| {:conditions => ["id < ? AND active = ?", p.id, true], :limit => 1, :order => "id DESC"} }

  scope :next_featured, lambda { |p| {:conditions => ["id > ? AND active = ? AND featured = ?", p.id, true, true], :limit => 1, :order => "id"} }
  scope :previous_featured, lambda { |p| {:conditions => ["id < ? AND active = ? AND featured = ?", p.id, true, true], :limit => 1, :order => "id DESC"} }

  scope :with_unseen_comments_for_user, lambda { |user| {
       :select => "DISTINCT stories.*",
       :joins => "INNER JOIN comments ON comments.story_id = stories.id INNER JOIN comments others_comments ON others_comments.story_id = stories.id INNER JOIN users ON comments.user_id = users.id ", 
       :conditions => ["users.id = ? AND (others_comments.created_at > comments.created_at AND others_comments.created_at > users.last_login_at)", user]
      }
  }
  
  scope :with_comments_for_user, lambda { |user| {
       :select => "DISTINCT stories.*", 
       :joins => "INNER JOIN comments ON comments.story_id = stories.id INNER JOIN comments others_comments ON others_comments.story_id = stories.id INNER JOIN users ON comments.user_id = users.id", 
       :conditions => ["users.id = ? AND (others_comments.created_at > comments.created_at OR others_comments.created_at > users.last_login_at OR stories.user_id = ?)", user, user]
        
      }
  }
  
  scope :new_comments_for_user_stories, lambda {|user| {
      :select => "DISTINCT stories.*", 
      :joins => "INNER JOIN comments others_comments ON others_comments.story_id = stories.id INNER JOIN users ON stories.user_id = users.id ",
      :conditions => ["stories.user_id = ? AND (others_comments.created_at > users.last_login_at)", user]
    }
  }
  
  scope :all_comments_for_user_stories, lambda {|user| {
      :select => "DISTINCT stories.*", 
      :joins => "INNER JOIN comments others_comments ON others_comments.story_id = stories.id",
      :conditions => ["stories.user_id = ?", user]
    }
  }  
  
  # Indexing for Searching with Sphinx
#  define_index do
#    indexes :title, :sortable => true
#    indexes :description
#    indexes :license, :sortable => true
#    indexes user.login, :as => "user"
#    indexes tags.name, :as => "tag"
#    indexes comments.comment, :as => "comments"
    
    
    # attributes
    
#    has tags(:id), :as => :tag_ids
    
#    has :updated_at
#    has :created_at
#    has :active
    
#    set_property :delta => true
#    where "stories.active = '1'"
    
#  end
  
    # Validation
    validates_presence_of   :title, :message => "Without a title, your story is invisible!"
    validates_presence_of   :description, :message => "Perhaps you should write a story."
    validates_presence_of   :license, :message => "What license?"
    validates_presence_of   :prompt_id, :message => "Prompt is necessary."
           
end
