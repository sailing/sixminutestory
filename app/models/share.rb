class Share < ActiveRecord::Base
  before_save :clean_url
  
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
    
    has :created_at
    has :active
    
    set_property :delta => true
    
  end
  
    # Validation 
    validates_presence_of     :link, :title, :description, :license, :source
    validates_format_of :link, :with => /https?:\/\/.*/i
    validates_format_of :website, :with => /https?:\/\/.*/i, :unless => :check_website?
    
    def link=(value)
      unless value =~ /https?:\/\/.*/
         write_attribute :link, "http://" + value.to_s
      else
         write_attribute :link, value
      end
    end
    
    def website=(value)
      unless value.blank?
        unless value =~ /https?:\/\/.*/
         write_attribute :website, "http://" + value.to_s
       else
         write_attribute :website, value
       end
      end
    end
    
    def check_website?
      self.website.blank?
    end
    
end
