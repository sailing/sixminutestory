class Share < ActiveRecord::Base
  acts_as_taggable
  acts_as_voteable
  
  belongs_to :user
  has_many :comments
  
  define_index do
    indexes :title, :sortable => true
    indexes :description
    indexes :license, :facet => true
    indexes :source, :facet => true
    indexes tags.name, :as => "tag_names", :facet => true
    indexes comments.comment, :as => "comments"
    
    # attributes
    
    has tags(:id), :as => :tag_ids
    
    has :created_at
    has :active
    
    set_property :delta => true
    
  end
    
end
