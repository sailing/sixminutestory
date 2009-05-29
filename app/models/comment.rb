class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :share

validates_presence_of :comment, :message => "You should probably leave a comment..."
end
