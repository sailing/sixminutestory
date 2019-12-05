class FollowingsController < ApplicationController
  before_action :authenticate_user_from_token!, :only => [:create, :destroy]
  before_action :authenticate_user!, :only => [:create, :destroy]

  def create
    @following = current_user.followings.build(:writer_id => params[:writer_id])
    if @following.save
      
      @user = User.find(params[:writer_id])
      Hermes.following_notification(@user, current_user).deliver if @user.following_notifications_on?
      
      respond_to do |format|
        format.html { 
					flash[:notice] = "Followed " + @user.login
          redirect_to profile_url(@user)

				}
				format.js {
         	# $("#following_toggle").html(render :partial => 'site/following_toggle', :locals => {:user => @user, :following => @following})
        }
      end
    end
  end
  
  def destroy
    #@following = current_user.followings.find_by_writer_id(params[:writer_id])
    @following = current_user.followings.find(params[:id])
    @user = User.find_by_id(@following.writer_id)
    if @following.destroy
      respond_to do |format|
        format.html {
          flash[:notice] = "Unfollowed " + @user.login
          redirect_to profile_url(@user)
        }
        format.js { 
					# $("#following_toggle").html(render :partial => 'site/following_toggle', :locals => {:user => @user, :following => nil})
        }
      end
    end
  end
end