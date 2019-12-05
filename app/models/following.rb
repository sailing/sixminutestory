class Following < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :writer, :class_name => "User"
end
