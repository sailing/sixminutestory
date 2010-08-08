class Prompt < ActiveRecord::Base
  belongs_to :user
  has_many :stories
  has_one :contest
  
  # Validations
#  validates_presence_of   :hero, :message => "Need a hero. Sort of Important."
#  validates_presence_of   :villain, :message => "Who's the villain?"
#  validates_presence_of   :goal, :message => "You may not have goals, but heroes do."
  validates_uniqueness_of :use_on, :allow_blank => true
end
