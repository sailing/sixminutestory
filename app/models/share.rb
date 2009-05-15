class Share < ActiveRecord::Base
  acts_as_taggable
  acts_as_voteable
  
  belongs_to :user
  has_many :comments
  
  define_index do
    indexes :title, :sortable => true
    indexes :description
    indexes :license, :facet => true
    indexes tags.name, :as => "tags_name"
    
    # attributes
    
    has tags(:id), :as => :tag_ids
    
    has :created_at
    has :active
    
    set_property :delta => true
    
  end
    
end
