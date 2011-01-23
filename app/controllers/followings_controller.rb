class FollowingsController < ApplicationController
  def create
    @following = current_user.followings.build(:writer_id => params[:writer_id])
    if @following.save
      @user = User.find(params[:writer_id])
      
      Hermes.following_notification(@user, current_user) unless (@user.send_followings == false or @user.email_address.blank?).deliver
      
      respond_to do |format|
        format.html { 
          render :update do |page| 
            page.replace_html 'following_toggle', :partial => 'site/following_toggle', :locals => {:user => @user, :following => @following}
          end
        }
      end
    end
  end
  
  def destroy
    @following = current_user.followings.find_by_writer_id(params[:writer_id])

    @user = User.find_by_id(@following.writer_id)
    if @following.destroy
      respond_to do |format|
        format.html { 
          render :update do |page|
            page.replace_html 'following_toggle', :partial => 'site/following_toggle', :locals => {:user => @user, :following => nil}
          end
        }
      end
    end
  end
end