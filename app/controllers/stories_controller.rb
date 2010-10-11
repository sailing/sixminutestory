class StoriesController < ApplicationController
  before_filter :require_user, :only => [:new, :create, :flag_story]
  before_filter :must_own_story, :only => [:edit, :destroy, :update]
  before_filter :must_be_admin, :only => [:admin, :disabled, :enable_story, :feature_story, :unfeature_story]
#  before_filter ensure_current_post_url, :only => :show
  
   def index 
       per_page = 10
       page = params[:page] || 1
      
      @truncate = true
      
      begin
      case request.path
        when /^\/popular/
            @stories = Story.active.popular.paginate :page => page, :per_page => per_page   
            @title = "popular stories"
        #    @popular = true
        when /^\/commented/
            @stories = Story.active.commented.paginate :page => page, :per_page => per_page
            @title = "most active stories"
            #@paginate = true
        when /^\/recent/
            @stories = Story.active.recent.paginate :page => page, :per_page => per_page
            @title = "most recent stories"
            @paginate = true
        when /^\/top/
            @stories = Story.active.top.paginate :page => page, :per_page => per_page   
            @title = "top rated stories"
        when /^\/tag\/./
            @tag = params[:tag]
            @stories = Story.tagged_with(@tag, :any => true).by_date.paginate :page => page, :per_page => per_page
            @title = "stories tagged with #{@tag}"
            @paginate = true
        when /^\/genre\/./
            @genre = params[:tag]
            @stories = Story.tagged_with(@genre, :on => :genres).by_date.paginate :page => page, :per_page => per_page
            @title = "stories in #{@genre} genre"
            @paginate = true
        #when /^\/account\/commented/
         #   @stories = Story.updated_after_users_last_comment_in_post(current_user)
          #  @title = "recent comments"
      else
          #return recent
          @stories = Story.active.recent.paginate :page => page, :per_page => per_page
          @title = "most recent stories"
          @paginate = true
      end
        
      rescue
           flash[:notice] = "There are no stories. Why not write your own?"
           redirect_to write_url
      else 
            respond_to do |format|
               format.html # index.html.erb
               format.xml  { render :xml => @stories }
               format.rss
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
      if @story.save
       
        #followers = Array.new
        #@story.user.followers.each do |follower|
        #  followers << follower.email_address
        #end
        
       # Hermes.deliver_new_story_notification(followers, @story, @story.user)
        
        format.html { redirect_to thanks_url(@story) }
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
  
 # GET /stories/1
  # GET /stories/1.xml
  def show
    session[:return_to] = request.url

    e = ActiveRecord::RecordNotFound
    begin
      
          unless request.path.include?("featured")
              if params[:id].present?
                @story = Story.find(params[:id], :conditions => {:active => true}, :include => :tags)
                @previous = Story.previous(@story)
                @next = Story.next(@story)              
              else
                @frontpage = true
                if @story = Story.active.featured.first
                  @featured = true
                  @previous_featured = Story.previous_featured(@story)
                  @next_featured = Story.next_featured(@story)
                else
                  @story = Story.active.top.first
                  @previous = Story.previous(@story)
                  @next = Story.next(@story)                              
                end
              end
          else
            if params[:id].blank?
              @story = Story.active.featured.first
              @featured = true
              @previous_featured = Story.previous_featured(@story)
              @next_featured = Story.next_featured(@story)
            elsif
              @story = Story.find(params[:id], :conditions => {:active => true, :featured => true}, :include => :tags)
              @featured = true
              @previous_featured = Story.previous_featured(@story)
              @next_featured = Story.next_featured(@story)
            end  
          end
       
    rescue Exception => e
      unless request.path.include?("featured")
        flash[:notice] = 'That story doesn\'t exist.'
      else
        flash[:notice] = 'That story isn\'t featured.'
      end
      store_location
      redirect_to recent_url
    
    else 
         # Initialize a comment 
           @comment = Comment.new
           @user = @story.user
           @prompt = Prompt.find_by_id(@story.prompt_id)
           
        # tests to see if a following relationship exists
           following_exists
          
        # find previous and next stories
        

           # increment story counter
           unless (current_user == @user)
            Story.increment_counter(:counter, @story)
           end

             respond_to do |format|
               format.html # show.html.erb
               format.xml  { render :xml => @story }
             end
    end
    
     
  end
  
  
  def tag_cloud
  e = ActiveRecord::RecordNotFound
      begin
        if request.path.include?("genres")
          @title = "genres"
          @tags = Story.tag_counts_on(:genres)
          @genres = true
        else
          @title = "adjectives"
           @tags = Story.tag_counts_on(:tags)
        end
      rescue Exception => e
        flash[:notice] = 'No genres have been tagged yet.'
        store_location
        redirect_to recent_url

      else
        respond_to do |format|
           format.html # tag_cloud.html.erb
         end
      end
  end
     
     
  def thanks_for_writing
      page = page || 1
      order = "created_at DESC"
      per_page = 15
    @story = Story.find(params[:id])
    @prompt = Prompt.find(@story.prompt_id)
    @stories = Story.paginate_by_prompt_id(@prompt.id, :page => page, :order => order, :per_page => per_page)
    
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
    e = ActiveRecord::RecordNotFound
    
        begin
          unless @prompt = Prompt.find_by_id(params[:prompt], :conditions => ["active = :active AND (use_on <= :today)", {:active => true, :today => Date.today}])
            unless @prompt = Prompt.find(:first, :conditions => {:use_on => Date.today,:active => true})
              @prompt = Prompt.find(:first,:order => "use_on DESC", :conditions => ["active = :active AND (use_on < :today)", {:active => true, :today => Date.today}])
             end
          end
        rescue Exception => e
          flash[:notice] = 'That prompt doesn\'t exist. Try this one instead.'
          redirect_to write_url
        else
          respond_to do |format|
            format.html # new.html.erb
            format.xml  { render :xml => @story }
          end
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

  end

  def enable_story
    @story = Story.find(params[:id])
    @story.active = 1
     respond_to do |format|
       if @story.save
         flash[:notice] = 'Story enabled.'
         format.html { redirect_to(stories_path) }
         format.xml  { head :ok }
       else
         flash[:notice] = 'Story NOT enabled.'
         format.html { redirect_to(stories_path) }
         format.xml  { render :xml => @story.errors, :status => :unprocessable_entity }
       end
     end
  end
  
  def destroy
    @story = Story.find(params[:id])

    @story.active = 0
     respond_to do |format|
       if @story.save
         flash[:notice] = 'Story disabled.'
         format.html { redirect_to(stories_path) }
         format.xml  { head :ok }
       else
         flash[:notice] = 'Story NOT disabled.'
         format.html { redirect_to(stories_path) }
         format.xml  { render :xml => @story.errors, :status => :unprocessable_entity }
       end
     end
  end
  
  def feature_story
    @story = Story.find(params[:id])
    @story.featured = 1
     respond_to do |format|
       if @story.save
         Hermes.deliver_featured_story_notification(@story.user, @story) unless (@story.user.send_stories == false or @story.user.email_address.blank?)
         
         flash[:notice] = 'Story featured.'
         format.html { redirect_to(read_featured_story_path(@story)) }
         format.xml  { head :ok }
       else
         flash[:notice] = 'Story NOT featured.'
         format.html { redirect_to(read_story_path(@story)) }
         format.xml  { render :xml => @story.errors, :status => :unprocessable_entity }
       end
     end
  end
  
  def unfeature_story
    @story = Story.find(params[:id])

    @story.featured = 0
     respond_to do |format|
       if @story.save
         flash[:notice] = 'Story unfeatured.'
         format.html { redirect_to(read_story_path(@story)) }
         format.xml  { head :ok }
       else
         flash[:notice] = 'Story still featured.'
         format.html { redirect_to(read_story_path(@story)) }
         format.xml  { render :xml => @story.errors, :status => :unprocessable_entity }
       end
     end
  end


  
  
  def flag_story
    @story = Story.find(params[:story], :readonly => false)
    @story.flagged += 1
    
     respond_to do |format|
       if @story.save!
         format.html { 
           render :update do |page| 
              page.replace_html :flag_button, "Flagged. Thanks."
            end
            }
         format.xml  { head :ok }         
       else
         flash[:notice] = 'Something went wrong at the story was not flagged. Please contact us directly.'
         format.html { redirect_to(read_story_url(@story)) }
         format.xml  { render :xml => @story.errors, :status => :unprocessable_entity }
       end
     end
    
  end
    

  private  
  
  def ensure_current_post_url
      redirect_to @story, :status => :moved_permanently unless @story.friendly_id_status.best?
  end
  
  def get_description
    if(request.xhr?)
      description = find.first()
      render :text => description
    end
  end
  
 

end
