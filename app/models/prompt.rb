class Prompt < ActiveRecord::Base
  belongs_to :user
  has_many :stories
  has_one :contest

end
