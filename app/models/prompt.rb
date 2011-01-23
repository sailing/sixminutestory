class Prompt < ActiveRecord::Base
  belongs_to :user
  has_many :stories
  has_one :contest
  acts_as_voteable
  
  scope :active, where(:active => true)
  scope :inactive, where(:active => false)
  scope :recent, lambda { where('created_at > ?', 5.months.ago).order('created_at DESC') }
  scope :popular, lambda { where('active = ? AND stories_count > ?', true, 0).limit(10).order('stories_count DESC, updated_at ASC') }
  scope :commented, lambda { where('(comments_count >= ?) AND created_at > ?', 2, 6.months.ago).order('comments_count DESC, rating DESC, counter DESC, updated_at ASC') }
  scope :featured, where(:featured => true).order('updated_at ASC').limit(1)
  scope :verified, lambda { where('active = ? AND use_on IS NOT ? AND use_on <= ?', true, nil, Date.today) }
  scope :unverified, lambda { where('active = ? AND (use_on IS ? OR use_on > ?)', true, nil, Date.today) }
  scope :images, lambda { where('active = ? AND kind = ? ', true, "flickr") }
  scope :hvg, lambda { where('active = ? AND kind = ? ', true, "hvg" ) }
  scope :firstlines, lambda { where('active = ? AND kind = ? ', true, "firstline" ) }
  scope :threewords, lambda { where('active = ? AND kind = ? ', true, "3ww" ) }
  # Validations
#  validates_presence_of   :hero, :message => "Need a hero. Sort of Important."
#  validates_presence_of   :villain, :message => "Who's the villain?"
#  validates_presence_of   :goal, :message => "You may not have goals, but heroes do."
  validates_uniqueness_of :use_on, :allow_blank => true

  FILTERS = [
    {:scope => "firstlines", :label => "First lines"},
    {:scope => "images",    :label => "Images"},
    {:scope => "hvg",       :label => "Hero Villain Goal"}

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

