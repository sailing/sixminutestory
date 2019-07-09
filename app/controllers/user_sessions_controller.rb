# app/controllers/user_sessions_controller.rb
class UserSessionsController < ApplicationController
  before_action :require_no_user, :only => [:new]
  before_action :require_user, :only => :destroy

  def index
      redirect_to current_user ? account_url : new_user_session_url
  end


  def new
    @user_session = UserSession.new
  end

  def create
                @user_session = UserSession.new(params[:user_session])
                @user_session.remember_me = true
                if @user_session.save
                        if @user_session.new_registration?
                                flash[:notice] = "Welcome! As a new user, please review your registration details before continuing..."
                                redirect_to edit_user_path( :current )
                        else
                                if @user_session.registration_complete?
                                        #flash[:notice] = "Successfully signed in."
                                        redirect_back_or_default account_path
                                else
                                        flash[:notice] = "Welcome back! Please complete required registration details before continuing..."
                                        redirect_to edit_user_path( :current )
                                end
                        end
                else
                        flash[:error] = "Failed to login or register."
                        redirect_to new_user_session_path
                end
        end


        def destroy
                    @user_session = current_user_session
                    @user_session.destroy if @user_session
                    #flash[:notice] = "Successfully signed out."
                    redirect_to root_url
            end

end
