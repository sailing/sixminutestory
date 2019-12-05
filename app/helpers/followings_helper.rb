module FollowingsHelper
  
  def is_following?(user)
    0 < Following.where("user_id = ? AND writer_id = ?",
             current_user.id, user.id).count
  end
end
