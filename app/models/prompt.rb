class Prompt < ActiveRecord::Base
  belongs_to :user
  has_many :stories
  has_one :contest
  
  scope :active, :conditions => {:active => true}
  scope :inactive, :conditions => {:active => false}
  scope :recent, lambda { { :conditions => ['created_at > ?', 5.months.ago], :order => 'created_at DESC' } }
  scope :popular, lambda { { :conditions => ['active = ? AND stories_count > ?', true, 0], :limit => 10, :order => 'stories_count DESC, updated_at ASC' } }
  scope :commented, lambda { { :conditions => ['(comments_count >= ?) AND created_at > ?', 2, 6.months.ago], :order => 'comments_count DESC, rating DESC, counter DESC, updated_at ASC' } }
  scope :featured, :limit => 1, :conditions => { :featured => true }, :order => 'updated_at ASC'
  scope :verified, lambda { { :conditions => ['active = ? AND use_on IS NOT ? AND use_on <= ?', true, nil, Date.today] } }
  scope :unverified, lambda { { :conditions => ['active = ? AND (use_on IS ? OR use_on > ?)', true, nil, Date.today] } }
  scope :images, lambda { { :conditions => ['active = ? AND kind = ? ', true, "flickr"]} }
  scope :hvg, lambda { { :conditions => ['active = ? AND kind = ? ', true, "hvg" ]} }
  scope :firstlines, lambda { { :conditions => ['active = ? AND kind = ? ', true, "firstline" ]} }
  scope :threewords, lambda { { :conditions => ['active = ? AND kind = ? ', true, "3ww" ]} }
  # Validations
#  validates_presence_of   :hero, :message => "Need a hero. Sort of Important."
#  validates_presence_of   :villain, :message => "Who's the villain?"
#  validates_presence_of   :goal, :message => "You may not have goals, but heroes do."
  validates_uniqueness_of :use_on, :allow_blank => true

  FILTERS = [
    {:scope => "verified",    :label => "All"},
    {:scope => "images",    :label => "Images"},
    {:scope => "hvg",       :label => "Hero Villain Goal"},
    {:scope => "firstlines", :label => "First lines"}
  ]

#  {:scope => "popular", :label => "Popular"} 
# {:scope => "threewords", :label => "#3WW"}

#  {:scope => "active",      :label => "Active"},
#   {:scope => "inactive",    :label => "Inactive"}, 
#   {:scope => "visible",     :label => "Visible"},
#   {:scope => "invisible",   :label => "Not Visible"},
#   {:scope => "high_rated",  :label => "High-Rated"},
#   {:scope => "low_rated",   :label => "Low-Rated"}
   
end
