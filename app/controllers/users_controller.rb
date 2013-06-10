# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:edit, :update]
  before_filter :must_be_admin, :only => [:index, :enable_user, :disable_user]

    def index
          page = params[:page] || 1
           per_page = 20
           order = params[:order] || "created_at DESC"

          @users = User.page(page).per(per_page).order(order)

        end

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

     e = ActiveRecord::RecordNotFound
      begin
       #@user = User.find_by_login(params[:login]) || User.find(params[:id]) || current_user
      @user = User.find params[:id] || current_user

      rescue Exception => e
        flash[:notice] = 'That user doesn\'t exist.'
        redirect_to root_url
      else

    if @user.present?

        page = params[:page] || 1
        per_page = 10
        order = "created_at DESC"

        @truncate = true
        @paginate = true

        if request.path.include?("profile") or (request.path.include?("profile") and request.format == "rss")
           @stories = @user.stories.active.page(page).per(per_page).order(order)
           @story = @stories.first if @stories.any?
           unless @story
              @story = @user.stories.build
            end

           @rss_url = "http://sixminutestory.com/profile/"+params[:id]+".rss"
            @profile = true
            @title = "Stories by " + @user.login


        elsif (request.path.include?("account") or (request.path.include?("rss") and request.format == "rss")) and !@user.writers.empty?
            @stories = Story.active.where(:user_id => @user.writers).page(page).per(per_page).order(order)
              #@rss_url = rss_url(@user.login, :format => :rss)
            @profile = false
            @title = "Stories by users you follow"
        else
           @stories = @user.stories.active.page(page).per(per_page).order(order)
           @story = @stories.first if @stories.any?
           unless @story
              @story = @user.stories.build
            end

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
    @user = current_user
    @user.valid?

  end

  def update
    @user = current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = 'Profile updated!'
      redirect_to account_url
    else
      render :action => :edit
    end
  end

  # This action has the special purpose of receiving an update of the RPX identity information
  # for current user - to add RPX authentication to an existing non-RPX account.
  # RPX only supports :post, so this cannot simply go to update method (:put)
  def addrpxauth
    @user = current_user
    if @user.save
      flash[:notice] = "Successfully added RPX authentication for this account."
      render :action => 'edit'
    else
      render :action => 'edit'
    end
  end

  def enable_user
    @user = User.find(params[:id])
    @user.active = 1
     respond_to do |format|
       if @user.save
         flash[:notice] = 'User enabled.'
         format.html { redirect_to(users_path) }
         format.xml  { head :ok }
       else
         flash[:notice] = 'User NOT enabled.'
         format.html { redirect_to(users_path) }
         format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
       end
     end
  end

  def disable_user
    @user = User.find(params[:id])

    @user.active = 0
     respond_to do |format|
       if @user.save
         flash[:notice] = 'User disabled.'
         format.html { redirect_to(users_path) }
         format.xml  { head :ok }
       else
         flash[:notice] = 'User NOT disabled.'
         format.html { redirect_to(users_path) }
         format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
       end
     end
  end





end
