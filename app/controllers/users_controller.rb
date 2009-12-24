# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
    before_filter :require_user, :only => [:edit, :update]
    
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
      @user.save do |result|
        if result
          Hermes.deliver_signup_notification(@user) unless @user.email_address.blank?
           redirect_to account_url
        else
          render :action => :new
        end
      end
  end

  def show
    
     e = ActiveRecord::RecordNotFound
      begin
       # @user = User.find_by_login(params[:login]) || User.find_by_id(params[:id]) || current_user
        @user = User.find(params[:id]) || current_user

      rescue Exception => e
        flash[:notice] = 'That user doesn\'t exist.'
        redirect_to root_url
      else
  if @user.present?
    
    page = params[:page] || 1
    per_page = 10
    order = "created_at DESC"
    

    
    
    if request.path.include?("profile") or (request.path.include?("profile") and request.format == "rss") 
      @stories = Story.paginate_by_user_id @user.id, :page => page, :order => order, :per_page => per_page, :conditions => {:active => true}    
      @rss_url = "http://sixminutestory.com/profile/"+@user.id.to_s+".rss"
      
    elsif (current_user == @user or (request.path.include?("personal") and request.format == "rss")) and !@user.writers.empty?
      @stories = Story.paginate_by_user_id @user.writers, :page => page, :order => order, :per_page => per_page, :conditions => {:active => true}    
      @rss_url = "http://sixminutestory.com/profile/personal/"+@user.id.to_s+".rss"
    else
      @stories = Story.paginate_by_user_id @user.id, :page => page, :order => order, :per_page => per_page, :conditions => {:active => true}    
    end
    
  
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @stories }
        format.rss
      end
  else
        flash[:notice] = 'That user doesn\'t exist.'
        redirect_to root_url
    end
    end
  end
  

  def edit
    @user = @current_user
  end

#  def update
#    @user = current_user # makes our views "cleaner" and more consistent
#    if @user.update_attributes(params[:user])
#      redirect_to account_url
#    else
#      render :action => :edit
#    end
#  end

  def update
    @user = current_user # makes our views "cleaner" and more consistent
    @user.attributes = params[:user]
    @user.save do |result|
      if result
        flash[:notice] = "Account updated!"
        redirect_to account_url
      else
        render :action => :edit
      end
     end
  end

  
end
