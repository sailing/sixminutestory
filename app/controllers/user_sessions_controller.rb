# app/controllers/user_sessions_controller.rb
class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  def new
    session[:return_to] = request.env["HTTP_REFERER"]
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    @user_session.save do |result|
        if result
          redirect_back_or_default root_url
        else
          flash[:notice] = "Username or password incorrect"
          redirect_back_or_default login_url
        end
      end
  end

  def destroy
    @current_user_session.destroy
    redirect_to root_url
  end
end
