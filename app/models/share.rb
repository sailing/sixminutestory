class Share < ActiveRecord::Base
  belongs_to :user
  
  define_index do
    indexes :title
    indexes :description
    
    has :created_at
    has :active
    
    set_property :delta => true
    
  end
    
end
