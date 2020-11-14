class Winner < ApplicationRecord
  belongs_to :contest
  belongs_to :story
  belongs_to :user

  validates_presence_of :contest, :story, :user, :winner_type
  validates :winner_type, inclusion: { in: %w(popular editors_choice),
    message: "%{value} is not a valid category" }

  scope :popular, -> { where(winner_type: :popular) }
  scope :editors_choice, -> { where(winner_type: :editors_choice) }
end
