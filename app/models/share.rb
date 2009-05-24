class Share < ActiveRecord::Base
  
  acts_as_taggable
  acts_as_voteable
  
  belongs_to :user
  has_many :comments
  
  define_index do
    indexes :title, :sortable => true
    indexes :description
    indexes :license, :sortable => true, :facet => true
    indexes :source, :sortable => true, :facet => true
    indexes tags.name, :as => "tag"
    indexes comments.comment, :as => "comments"
    
    # attributes
    
    has tags(:id), :as => :tag_ids
    
    has :updated_at
    has :created_at
    has :active
    
    set_property :delta => true
    
  end
  
    # Validation 
    validates_presence_of   :link, :message => "Without a link, we can't find it!"
    validates_presence_of   :title, :message => "Without a title, your share is invisible!"
    validates_presence_of   :description, :message => "What are you sharing?"
    validates_presence_of   :license, :message => "Is it open, shareable and free?"
    validates_presence_of   :source, :message => "Credit where credit is due!"
    validates_format_of :link, :with => /https?:\/\/.*/i, :message => "Please start URLs with http:// or https://"
    validates_format_of :website, :with => /https?:\/\/.*/i, :message => "Please start URLs with http:// or https://", :unless => :check_website?
       
    def check_website?
      self.website.blank?
    end
    
end
