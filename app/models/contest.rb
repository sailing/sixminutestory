class Contest < ActiveRecord::Base
  # Use these for duration setting
  attr_accessor :starts_at, :ends_at

  belongs_to :prompt
  belongs_to :user

  has_many :stories
  has_many :users, through: :stories

  has_many :popular_winners, -> { where( Winner.popular ) }, class_name: "Winner"
  has_many :editors_choice_winners, -> { where( Winner.editors_choice ) }, class_name: "Winner"
  has_many :winning_stories, through: :winners, class_name: "Story"

  scope :approved, -> { where( approved: true ) }

  before_validation :compose_duration

  def compose_duration
    self.duration = self.starts_at..self.ends_at
  end

  def starts_at
    @starts_at ||= self.duration.first
  end

  def ends_at
    @ends_at ||= self.duration.last
  end

end