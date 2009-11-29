class Story < ActiveRecord::Base
  
  acts_as_taggable_on :tags
  acts_as_voteable
  
#  has_friendly_id :title, :use_slug => true
  
  belongs_to :user
  has_one :prompt
  has_one :contest
  has_many :comments  
  
  define_index do
    indexes :title, :sortable => true
    indexes :description
    indexes :license, :sortable => true
    indexes user.login, :as => "user"
    indexes tags.name, :as => "tag"
    indexes comments.comment, :as => "comments"
    
    
    # attributes
    
    has tags(:id), :as => :tag_ids
    
    has :updated_at
    has :created_at
    has :active
    
    set_property :delta => true
    where "stories.active = '1'"
    
  end
  
    # Validation 
    validates_presence_of   :title, :message => "Without a title, your story is invisible!"
    validates_presence_of   :description, :message => "Perhaps you should write a story."
    validates_presence_of   :license, :message => "What license?"
           
end
