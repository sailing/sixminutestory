# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
    before_filter :require_user, :only => [:edit, :update]
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.admin_level = 1;
    if verify_recaptcha && @user.save
        Hermes.deliver_signup_notification(@user)
        redirect_to account_url
      else
        render :action => :new
    end
  end

  def show
    @user = User.find_by_login(params[:login]) || current_user || User.find_by_id(params[:id])
    
    # tests to see if a following relationship exists
    following_exists
    
    page = params[:page] || 1
    per_page = 10
    order = "created_at DESC"
    
    if current_user == @user or request.format == "rss"
      if @user.followings.present? 
        writers = Array.new
        @user.followings.each do |writer|
          writers << writer.writer_id
        end
      else
        writers = nil
      end
      
      @stories = Story.paginate_by_user_id writers, :page => page, :order => order, :per_page => per_page, :conditions => {:active => true}    
    else  
      @stories = Story.paginate_by_user_id @user.id, :page => page, :order => order, :per_page => per_page, :conditions => {:active => true}    
    end
    
    respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @stories }
        format.rss
      end
  end
  

  def edit
    @user = @current_user
  end

  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      redirect_to account_url
    else
      render :action => :edit
    end
  end  
  
end
