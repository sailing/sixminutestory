class StoriesController < ApplicationController
  before_filter :require_user, :only => [:new, :create, :flag_story, :update]
  before_filter :must_own_story, :only => [:edit, :destroy]
  before_filter :must_be_admin, :only => [:admin, :disabled, :enable_story, :feature_story, :unfeature_story]
  after_filter :increment_counter, :only => [:show]
#  before_filter ensure_current_post_url, :only => :show
  
   def index 
       per_page = 10
       page = params[:page] || 1
       
       
        if params[:months]
          months = params[:months].to_i.abs
          timeframe = Time.now.months_ago(months)
        elsif params[:days]
          days = params[:days].to_i.abs
          days = -days
          timeframe = Time.now.advance(:days => days)
        else
          timeframe = Time.now.months_ago(1)
        end
        
        
          unless (params[:months] or params[:days])
            order = "created_at DESC"
          else
            order = "created_at ASC"
          end
        
      @truncate = true
      
      begin
        case params[:subset]
          when /popular/
              @stories = Story.recent(timeframe).popular.paginate :page => page, :per_page => per_page   
              @title = "popular stories"
          when /active/
              @stories = Story.recent(timeframe).commented.paginate :page => page, :per_page => per_page
              @title = "most active stories"
          when /recent/
              @stories = Story.recent(timeframe).paginate :page => page, :per_page => per_page, :order => order          
              @title = "most recent stories"
          when /top/
              @stories = Story.recent(timeframe).top.paginate :page => page, :per_page => per_page
              @title = "top rated stories"
          when /featured/
              @stories = Story.recent(timeframe).featured.paginate  :page => page, :per_page => per_page
              @title = "editors' picks"
          when /adjective/
              @adjective = params[:tag]
              @stories = Story.tagged_with([@adjective], :any => true).paginate :page => page, :per_page => per_page, :order => order
              @title = "stories tagged with #{@tag}"
          when /genre/
              @genre = params[:tag]
              @stories = Story.recent(timeframe).tagged_with([@genre], :any => true, :on => :genres).paginate :page => page, :per_page => per_page, :order => order
              @title = "stories in #{@genre} genre"
          when /emotion/
                @emotion = params[:tag].downcase
                @stories = Story.recent(timeframe).tagged_with([@emotion], :any => true, :on => :emotions).paginate :page => page, :per_page => per_page, :order => order
                @title = "these stories evoked #{@emotion}"
        
          
        else
            #return featured
            @stories = Story.recent(timeframe).featured.paginate  :page => page, :per_page => per_page
            @title = "editors' picks"
        end
        
      rescue
           flash[:notice] = "There are no stories. Why not write your own?"
           redirect_to faq_url
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
                    
        format.html { redirect_to thanks_story_url(@story) }
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
    
    if request.xhr?
        # add the given tag to the story

          emotion = params[:emotion_list] || params[:story][:emotion_list]

          @story.emotion_list << emotion
          @story.save
          
          respond_to do |format|
            format.js { 
              render :update do |page| 
                page.replace_html 'respond_emotions', :partial => "emotions", :object => @story
                page.visual_effect :highlight, 'emotions'
              end
            }
          end
    else
    
    respond_to do |format|
      if @story.update_attributes(params[:story])
        format.html { redirect_to story_url(@story) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @story.errors, :status => :unprocessable_entity }
      end
    end
  end
  end
  
 # GET /stories/1
  # GET /stories/1.xml
  def show
    session[:return_to] = request.url

    e = ActiveRecord::RecordNotFound
    begin
                @story = Story.active.find(params[:id])
                @previous = Story.previous(@story).first
                @next = Story.next(@story).first              
                @previous_featured = Story.previous_featured(@story).first
                @next_featured = Story.next_featured(@story).first
                                
       
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

        # Get info for the story
           @user = @story.user
           @prompt = @story.prompt
           @emotions = Story.find(@story).tag_counts_on(:emotions)
           
        # tests to see if a following relationship exists
           following_exists
  

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
          @subset = "genre"
        elsif request.path.include?("emotions")
          @title = "emotions"
          @tags = Story.tag_counts_on(:emotions)
          @emotions = true
          @subset = "emotion"
        else
          @title = "adjectives"
           @tags = Story.tag_counts_on(:tags)
           @subset = "adjective"
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
     
     
  def thanks
      page = page || 1
      order = "created_at DESC"
      per_page = 15
    @story = Story.find(params[:id])
    @prompt = @story.prompt
    @stories = Story.active.where(:prompt_id => @prompt.id).paginate(:page => page, :order => order, :per_page => per_page)
    
  end
  
  def random
    e = ActiveRecord::RecordNotFound
    begin
      get_random()
    rescue Exception => e
      redirect_to random_stories_url
    else
      redirect_to story_url(@story)
      
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
         Hermes.featured_story_notification(@story.user, @story) unless (@story.user.send_stories == false or @story.user.email_address.blank?).deliver
         
         flash[:notice] = 'Story featured.'
         format.html { redirect_to(featured_path(@story)) }
         format.xml  { head :ok }
       else
         flash[:notice] = 'Story NOT featured.'
         format.html { redirect_to(story_url(@story)) }
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
         format.html { redirect_to(story_url(@story)) }
         format.xml  { head :ok }
       else
         flash[:notice] = 'Story still featured.'
         format.html { redirect_to(story_url(@story)) }
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
         format.html { redirect_to(story_url(@story)) }
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
  
 def increment_counter
  if @story && @user
    # increment story counter
     unless (current_user == @user)
      Story.increment_counter(:counter, @story)
     end
  end
 end

end
