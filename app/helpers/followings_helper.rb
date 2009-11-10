module FollowingsHelper
  
  def is_following?(user)
    0 < Following.count(:all, :conditions => [
             "user_id = ? AND writer_id = ?",
             current_user.id, user.id
             ])
  end
end
