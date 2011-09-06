class Prompt < ActiveRecord::Base
  belongs_to :user
  has_many :stories
  has_one :contest
  acts_as_voteable

	attr_accessor :hvg, :flickr, :startline

  scope :active, where(:active => true)
  scope :inactive, where(:active => false)
  scope :recent, lambda { where('created_at > ?', 5.months.ago).order('created_at DESC') }
  scope :top, lambda { where('votes_count > ?', 0).order('votes_count DESC')}
  scope :popular, lambda { where('active = ? AND stories_count > ?', true, 0).limit(10).order('stories_count DESC, updated_at ASC') }
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
   
	def license_in_human_terms(prompt)
		if prompt.license.present? && prompt.license_url.blank?
			case prompt.license
				when "1", "cc-by-nc-sa"
					prompt.license_en = "Attribution-NonCommercial-ShareAlike License"
					prompt.license_url = "http://creativecommons.org/licenses/by-nc-sa/2.0/"
					prompt.license_image_url = "http://i.creativecommons.org/l/by-nc-sa/3.0/88x31.png"
				when "2", "cc-by-nc"
					prompt.license_en = "Attribution-NonCommercial License"
					prompt.license_image_url = "http://i.creativecommons.org/l/by-nc/3.0/88x31.png"
					prompt.license_url = "http://creativecommons.org/licenses/by-nc/2.0/"
				when "3", "cc-by-nc-nd" 
					prompt.license_en = "Attribution-NonCommercial-NoDerivs License"
					prompt.license_image_url = "http://i.creativecommons.org/l/by-nc-nd/3.0/88x31.png"
					prompt.license_url = "http://creativecommons.org/licenses/by-nc-nd/2.0/"
				when "4", "cc-by" 
					prompt.license_en = "Attribution License"
					prompt.license_url = "http://creativecommons.org/licenses/by/2.0/"				
					prompt.license_image_url = "http://i.creativecommons.org/l/by/3.0/88x31.png"
				when "5", "cc-by-sa" 
					prompt.license_en = "Attribution-ShareAlike License"
					prompt.license_image_url = "http://i.creativecommons.org/l/by-sa/3.0/88x31.png"
					prompt.license_url = "http://creativecommons.org/licenses/by-sa/2.0/"
				when "6", "cc-by-nd"
					prompt.license_en = "Attribution-NoDerivs License"
					prompt.license_image_url = "http://i.creativecommons.org/l/by-nd/3.0/88x31.png"
					prompt.license_url = "http://creativecommons.org/licenses/by-nd/2.0/"
				else
					prompt.license_en = "No known copyright restrictions"
					prompt.license_url = "http://flickr.com/commons/usage/"
			end
			prompt.save
			return prompt
		end
	end
end

