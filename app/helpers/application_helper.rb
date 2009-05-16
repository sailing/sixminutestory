# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

    def edit_this(share = {})
      share = share ? share : @share
      if current_user && ((@user.present? && current_user.id == @user.id) || (share.present? && current_user.id == share.user_id) || (@share.present? && current_user.id == @share.user_id))
      
            link_to 'Edit', edit_share_path(share)
      
      #  if @share 
       #   if current_user.id == @share.user_id
        #    link_to 'Edit', edit_share_path(@share) 
        #  end
      #  end  
      end
    
    end

end
