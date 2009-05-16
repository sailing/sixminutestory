# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
    before_filter :require_user, :only => [:show, :edit, :update]
    
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_back_or_default account_url
    else
      render :action => :new
    end
  end

  def show
    @user = @current_user
    page = params[:page] || 1
    per_page = 10
    condition = true
    order = "created_at DESC"
    @shares = Share.paginate_by_user_id @user.id, :page => page, :order => order, :per_page => per_page, :conditions => {:active => condition}    
  end
  
  def profile
     @user = User.find(params[:id])
     page = params[:page] || 1
     per_page = 7
     condition = true
     order = "created_at DESC"
     @shares = Share.paginate_by_user_id @user.id, :page => page, :order => order, :per_page => per_page, :conditions => {:active => condition}    

         @i = 0
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
