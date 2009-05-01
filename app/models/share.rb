class Share < ActiveRecord::Base
  acts_as_taggable
  belongs_to :user
  
  define_index do
    indexes :title, :sortable => true
    indexes :description
    
    has :created_at
    has :active
    
    set_property :delta => true
    
  end
    
end
