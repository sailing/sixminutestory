class Contest < ActiveRecord::Base
  belongs_to :user
  has_many :stories
  has_one :prompt
end
