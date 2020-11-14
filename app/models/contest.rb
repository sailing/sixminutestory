class Contest < ActiveRecord::Base
  # Use these for duration setting
  attr_accessor :starts_at, :ends_at

  belongs_to :prompt
  belongs_to :user

  has_many :stories
  has_many :users, through: :stories
end