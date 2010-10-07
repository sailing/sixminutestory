class Story < ActiveRecord::Base
  #acts_as_taggable  
  acts_as_taggable_on :tags
  acts_as_taggable_on :genres
  acts_as_voteable
  
  has_friendly_id :title, :use_slug => true
  
  belongs_to :user, :counter_cache => true
  belongs_to :prompt, :counter_cache => true
  has_one :contest
  has_many :comments
  # Named Scopes
  
  named_scope :active, :conditions => {:active => true}
  named_scope :inactive, :conditions => {:active => false}
  named_scope :recent, lambda { { :conditions => ['created_at > ?', 2.weeks.ago], :order => 'created_at DESC' } }
  named_scope :popular, lambda { { :conditions => ['(comments_count >= ? or rating >= ?) AND created_at > ?', 0, 0, 2.months.ago], :order => 'counter DESC, rating DESC, updated_at ASC' } }
  named_scope :commented, lambda { { :conditions => ['(comments_count >= ?) AND created_at > ?', 1, 5.days.ago], :order => 'comments_count DESC, rating DESC, counter DESC, updated_at ASC' } }
  named_scope :top, lambda { { :conditions => ['rating > 0'], :order => 'rating DESC, counter ASC' } }
  named_scope :featured, :limit => 1, :conditions => ['featured = ? AND created_at > ?', true, 1.month.ago], :order => 'updated_at ASC'
  
  # Filters
  named_scope :by_date, :order => "created_at DESC"
  
  # Next and Previous links
  named_scope :next, lambda { |p| {:conditions => ["id > ? AND active = ?", p.id, true], :limit => 1, :order => "id"} }
  named_scope :previous, lambda { |p| {:conditions => ["id < ? AND active = ?", p.id, true], :limit => 1, :order => "id DESC"} }

  named_scope :next_featured, lambda { |p| {:conditions => ["id > ? AND active = ? AND featured = ?", p.id, true, true], :limit => 1, :order => "id"} }
  named_scope :previous_featured, lambda { |p| {:conditions => ["id < ? AND active = ? AND featured = ?", p.id, true, true], :limit => 1, :order => "id DESC"} }

#  named_scope :with_unseen_comments_for_user, lambda { |user| {
#       :select => "DISTINCT stories.*", :joins => "INNER JOIN comments, 
#         comments others_comments, users ON (comments.user_id = users.id AND 
#          others_comments.story_id = story.id AND comments.story_id = stories.id", 
#        :conditions => ["users.id = ? AND 
#          comments_stories.updated_at > users.updated_at", user]
#      }
#  }
    
  
  
  
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
