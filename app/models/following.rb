class Following < ActiveRecord::Base
  attr_accessible :user_id, :writer_id
  
  belongs_to :user
  belongs_to :writer, :class_name => "User"
end
