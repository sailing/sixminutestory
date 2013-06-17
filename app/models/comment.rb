class Comment < ActiveRecord::Base
  belongs_to :user, :counter_cache => true
  belongs_to :story, :counter_cache => true

  acts_as_voteable
  attr_accessible :comment

	validates_presence_of :comment, :message => "You should probably leave a comment..."
end
