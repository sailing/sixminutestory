class Prompt < ActiveRecord::Base
  belongs_to :user
  has_many :stories
  has_one :contest
  acts_as_voteable

  before_create :convert_license_to_human_terms

	attr_accessor :hvg, :flickr, :startline

  scope :active, -> {where(:active => true)}
  scope :inactive, -> {where(:active => false)}
  scope :usable, -> { active.where("use_on > ?", Time.now)}
  scope :recent, lambda { where('created_at > ?', 5.months.ago).order('created_at DESC') }
  scope :top, lambda { where('votes_count > ?', 0).order('votes_count DESC')}
  scope :popular, lambda { active.where('stories_count > ?', 0).limit(10).order('stories_count DESC, updated_at ASC') }
  scope :featured, -> {where(:featured => true).order('updated_at ASC').limit(1)}
  scope :verified, lambda { active.where('use_on IS NOT ? AND use_on <= ?', nil, Date.today) }
  scope :unverified, lambda { active.where('(use_on IS ? OR use_on > ?)', nil, Date.today) }
  scope :images, lambda { active.where('kind = ? ', "flickr") }
  scope :hvg, lambda { active.where('kind = ? ', "hvg" ) }
  scope :firstlines, lambda { active.where('kind = ? ', "firstline" ) }
  scope :threewords, lambda { active.where('kind = ? ', "3ww" ) }
  
  # Validations
  validates_uniqueness_of :use_on, :allow_blank => true

  FILTERS = [
    {:scope => "firstlines", :label => "First lines"},
    {:scope => "images",    :label => "Images"},
    {:scope => "hvg",       :label => "Hero Villain Goal"}

  ]

	def self.random
	  active.where(id: Prompt.active.pluck(:id).sample).first
	end

	def convert_license_to_human_terms
		if license.present? && license_url.blank?
			case license
				when "1", "cc-by-nc-sa"
					self.license_en = "Attribution-NonCommercial-ShareAlike License"
					self.license_url = "http://creativecommons.org/licenses/by-nc-sa/2.0/"
					self.license_image_url = "http://i.creativecommons.org/l/by-nc-sa/3.0/88x31.png"
				when "2", "cc-by-nc"
					self.license_en = "Attribution-NonCommercial License"
					self.license_image_url = "http://i.creativecommons.org/l/by-nc/3.0/88x31.png"
					self.license_url = "http://creativecommons.org/licenses/by-nc/2.0/"
				when "3", "cc-by-nc-nd"
					self.license_en = "Attribution-NonCommercial-NoDerivs License"
					self.license_image_url = "http://i.creativecommons.org/l/by-nc-nd/3.0/88x31.png"
					self.license_url = "http://creativecommons.org/licenses/by-nc-nd/2.0/"
				when "4", "cc-by"
					self.license_en = "Attribution License"
					self.license_url = "http://creativecommons.org/licenses/by/2.0/"
					self.license_image_url = "http://i.creativecommons.org/l/by/3.0/88x31.png"
				when "5", "cc-by-sa"
					self.license_en = "Attribution-ShareAlike License"
					self.license_image_url = "http://i.creativecommons.org/l/by-sa/3.0/88x31.png"
					self.license_url = "http://creativecommons.org/licenses/by-sa/2.0/"
				when "6", "cc-by-nd"
					self.license_en = "Attribution-NoDerivs License"
					self.license_image_url = "http://i.creativecommons.org/l/by-nd/3.0/88x31.png"
					self.license_url = "http://creativecommons.org/licenses/by-nd/2.0/"
				else
					self.license_en = "No known copyright restrictions"
					self.license_url = "http://flickr.com/commons/usage/"
			end
			self.save
			return self
		end
	end
end

