class StoriesController < ApplicationController
  before_filter :require_user, :only => [:new, :create, :edit, :update, :destroy]
  before_filter :must_be_admin, :only => [:admin, :disabled, :enable_story, :disable_story]
  before_filter ensure_current_post_url, :only => :show
  
 # GET /stories/1
  # GET /stories/1.xml
  def show

    e = ActiveRecord::RecordNotFound
    begin
      @story = Story.find(params[:id], :conditions => {:active => true}, :include => :tags)
      
    rescue Exception => e
      flash[:notice] = 'That story doesn\'t exist.'
      store_location
      redirect_to read_url
    else 
         # Initialize a comment 
           @comment = Comment.new
           @user = @story.user
           @prompt = Prompt.find_by_id(@story.prompt_id)
           
        # tests to see if a following relationship exists
           following_exists
          
        # find previous and next stories
             @previous = @story.id - 1
             @next = @story.id + 1

           if Story.find_by_id(@previous,:conditions => {:active => true})
             @previous = @previous
           else 
             @previous = "#"
           end


           if Story.find_by_id(@next,:conditions => {:active => true})
             @next = @next
           else 
             @next = "#"
           end

           # increment story counter
             if @story.counter 
               @story.counter += 1 
               @story.save ? @saved = "saved" : @saved = "not saved"
             end

             respond_to do |format|
               format.html # show.html.erb
               format.xml  { render :xml => @story }
             end
    end
    
     
  end
  
  def random
    e = ActiveRecord::RecordNotFound
    begin
      get_random()
    rescue Exception => e
      redirect_to read_random_url
    else
      redirect_to read_story_url(@story)
      
    end
      
  end

  # GET /stories/new
  # GET /stories/new.xml
  def new
    @story = Story.new
      if params[:prompt].present?  
        @prompt = Prompt.find_by_id(params[:prompt], :conditions => ["active = :active AND (use_on <= :today)", {:active => true, :today => Date.today}])
      else
       unless @prompt = Prompt.find(:first, :conditions => {:use_on => Date.today,:active => true})
        @prompt = Prompt.find(:first,:order => "use_on DESC", :conditions => ["active = :active AND (use_on < :today)", {:active => true, :today => Date.today}])
       end
      end
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @story }
    end
  end


  def admin
      page = params[:page] || 1
      per_page = 15
      order = "created_at DESC"

      @stories = Story.paginate :page => page, :order => order, :per_page => per_page, :conditions => {:active => true}

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stories }
    end
  end

  def disabled
      page = params[:page] || 1
      per_page = 15
      order = "updated_at DESC"

      @stories = Story.paginate :page => page, :order => order, :per_page => per_page, :conditions => {:active => false}

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stories }
    end
  end


  # GET /stories/1/edit
  def edit
    @story = Story.find(params[:id])
    @editing = true
  end

  def enable_story
    @story = Story.find(params[:id])
    @story.active = 1
     respond_to do |format|
       if @story.save
         flash[:notice] = 'Story enabled.'
         format.html { redirect_to(stories_admin_path) }
         format.xml  { head :ok }
       else
         flash[:notice] = 'Story NOT enabled.'
         format.html { redirect_to(stories_admin_path) }
         format.xml  { render :xml => @story.errors, :status => :unprocessable_entity }
       end
     end
  end
  
  def disable_story
    @story = Story.find(params[:id])

    @story.active = 0
     respond_to do |format|
       if @story.save
         flash[:notice] = 'Story disabled.'
         format.html { redirect_to(stories_admin_path) }
         format.xml  { head :ok }
       else
         flash[:notice] = 'Story NOT disabled.'
         format.html { redirect_to(stories_admin_path) }
         format.xml  { render :xml => @story.errors, :status => :unprocessable_entity }
       end
     end
  end

  # POST /stories
  # POST /stories.xml
  def create
    @story = Story.new(params[:story])
    @story.user_id = @current_user.id
    @story.prompt_id = params[:prompt]
    @prompt = Prompt.find_by_id(@story.prompt_id)
 
    respond_to do |format|
      if verify_recaptcha && @story.save
        @prompt.counter += 1 
        @prompt.save
        
        followers = Array.new
        @story.user.followers.each do |follower|
          followers << follower.email_address
        end
        
       # Hermes.deliver_new_story_notification(followers, @story, @story.user)
        
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
  
  
  def flag_story
    @story = Story.find(params[:story])
    @story.flagged += 1
     respond_to do |format|
       if @story.save
         flash[:notice] = 'Thank you for flagging the story.'
         format.html { redirect_to(read_story_url(@story)) }
         format.xml  { head :ok }
       else
         flash[:notice] = 'Something went wrong at the story was not flagged. Please contact us directly.'
         format.html { redirect_to(read_story_url(@story)) }
         format.xml  { render :xml => @story.errors, :status => :unprocessable_entity }
       end
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
