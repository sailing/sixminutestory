module SharesHelper

  def edit_this
     link_to 'Edit', edit_share_path(@share) if current_user && current_user.id == @share.user_id
   end

end
