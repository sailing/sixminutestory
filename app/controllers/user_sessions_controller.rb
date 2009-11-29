# app/controllers/user_sessions_controller.rb
class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    @user_session.save do |result|
        if result
          redirect_back_or_default account_url
        else
          flash[:notice] = "Username or password incorrect"
          redirect_to login_url
        end
      end
  end

  def destroy
    @current_user_session.destroy
    redirect_to root_url
  end
end
