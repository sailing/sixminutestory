class StoriesController < ApplicationController
  before_filter :require_user, :only => [:new, :create, :edit, :update, :destroy]
  
  
 # GET /stories/1
  # GET /stories/1.xml
  def show
    page = params[:page] || 1
    per_page = 10
    condition = true
    order = "created_at DESC"
    @story = Story.find(params[:id], :conditions => {:active => true}, :include => :tags)
    @comment = Comment.new
    
    # Comments

#    @comments = Comment.paginate :all, :page => page, :per_page => per_page, :order => order, :conditions => {:story_id => params[:id]}
      
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @story }
    end
  end

  # GET /stories/new
  # GET /stories/new.xml
  def new
    @story = Story.new
    params[:prompt].present? ? @prompt = Prompt.find_by_id(params[:prompt], :conditions => {:active => true, :verified => true}) : @prompt = Prompt.find(:first, :conditions => {:use_on => Date.today,:active => true, :verified => true})
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @story }
    end
  end

  # GET /stories/1/edit
  def edit
    @story = Story.find(params[:id])
    @editing = true
  end

  # POST /stories
  # POST /stories.xml
  def create
    @story = Story.new(params[:story])
    @prompt = Prompt.find_by_id(params[:prompt])
    
    respond_to do |format|
      if verify_recaptcha && @story.save
        @user = @current_user
        @story.update_attribute("user_id", @user.id)
        format.html { redirect_to(@story) }
        format.xml  { render :xml => @story, :status => :created, :location => @story }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @story.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /stories/1
  # PUT /stories/1.xml
  def update
    @story = Story.find(params[:id])

    respond_to do |format|
      if @story.update_attributes(params[:story])
        format.html { redirect_to(@story) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @story.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /stories/1
  # DELETE /stories/1.xml
  def destroy
    @story = Story.find(params[:id])
    @story.active = false
    @story.save

    respond_to do |format|
      format.html { redirect_to(account_url) }
      format.xml  { head :ok }
    end
  end
  
  
  private
  
  def get_description
    if(request.xhr?)
      description = find.first()
      render :text => description
    end
  end
  
 

end
