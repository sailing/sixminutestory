class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :story

validates_presence_of :comment, :message => "You should probably leave a comment..."
end
