class FollowingsController < ApplicationController
  def create
    @following = current_user.followings.build(:writer_id => params[:writer_id])
    if @following.save
      respond_to do |format|
        format.html { 
          @user = User.find(params[:writer_id])
          render :update do |page| 
            page.replace_html 'following_toggle', :partial => 'site/following_toggle', :locals => {:user => @user, :following => @following}
          end
        }
      end
    end
  end
  
  def destroy
    @following = current_user.followings.find_by_writer_id(params[:writer_id]) || current_user.followings.find(params[:id])
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