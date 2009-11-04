class FollowingsController < ApplicationController
  def create
    @following = current_user.followings.build(:writer_id => params[:writer_id])
    if @following.save
      flash[:notice] = "You're a fan!"
      redirect_to account_url
    else
      flash[:error] = "Unable to follow."
      redirect_to account_url    
    end
  end
  
  def destroy
    @following = current_user.followings.find(params[:id])
    @following.destroy
    flash[:notice] = "You're not a fan of them."
    redirect_to account_url
  end
end
