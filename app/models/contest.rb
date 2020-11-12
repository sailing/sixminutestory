class Contest < ApplicationRecord
  has_one :prompt
  belongs_to :user

  has_many :stories
  has_many :users, through: :stories
end
