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


						if (params[:months] or params[:days])
              order = "created_at ASC"
          	else
            	order = "created_at DESC"
          	end

      @truncate = true

      begin
        case params[:subset]
          when /popular/
              @stories = Story.includes(:user).recent(timeframe).popular.page(page).per(per_page)
              @title = "Popular stories"
          when /active/
              @stories = Story.recent(timeframe).commented.page(page).per(per_page)
              @title = "Active stories"
          when /recent/
              @stories = Story.recent(timeframe).page(page).per(per_page)
              @title = "Recent stories"
          when /top/
              @stories = Story.recent(timeframe).top.page(page).per(per_page)
              @title = "Top rated stories"
          when /featured/
              @stories = Story.recent(timeframe).featured.page(page).per(per_page)
              @title = "Editors' picks"
          when /adjective/
              @adjective = params[:tag]
              @stories = Story.recent(timeframe).tagged_with([@adjective], :any => true).page(page).per(per_page)
              @title = "Stories tagged with #{@adjective}"
          when /genre/
              @genre = params[:tag]
              @stories = Story.includes(:user).recent(timeframe).tagged_with([@genre], :any => true, :on => :genres).page(page).per(per_page)
              @title = "Stories in #{@genre} genre"
          when /emotion/
                @emotion = params[:tag].downcase
                @stories = Story.recent(timeframe).tagged_with([@emotion], :any => true, :on => :emotions).page(page).per(per_page)
                @title = "These stories evoked #{@emotion}"


        else
            #return featured
            #@stories = Story.recent(timeframe).featured.page(page).per(per_page)
            #@title = "editors' picks"
						 @stories = Story.recent(timeframe).page(page).per(per_page)
              @title = "Recent stories"
							@frontpage = true
        end
      rescue
           flash[:notice] = "There are no stories. Why not write your own?"
           redirect_to faq_url
      else
          @titles = @stories.map(&:title)
            respond_to do |format|
               format.html # index.html.erb
               format.xml  { render :xml => @stories }
               format.rss
             end
      end


   end

  # GET /stories/new
  # GET /stories/new.xml
  def new
    @story = Story.new

    begin
      unless params[:prompt].present? && @prompt = Prompt.find_by_id(params[:prompt], :conditions => ["active = :active AND (use_on <= :today)", {:active => true, :today => Date.today}])
        unless @prompt = Prompt.find(:first, :conditions => {:use_on => Date.today,:active => true})
          FlickRaw.api_key="615dc15889c27e7e570b16fb7f7b7431"
          FlickRaw.shared_secret="4fdb5165d72fdd38"

          @prompt = Prompt.new

          if photo = flickr.photos.search(:license => "4,5,7", :sort => "interestingness-desc", :safe_search => 1, :content_type => 1, :extras => "url_m, owner_name, license", :per_page => 1, :group_id => "11252682@N00",:text => "-landscape -cityscape -sunset person")
            i = 0
            until (photo.present? && Prompt.find_by_refcode(photo[0].url_m).blank?) do
              photo = flickr.photos.search(:license => "4,5,7", :sort => "interestingness-desc", :safe_search => 1, :content_type => 1, :extras => "url_m, owner_name, license", :per_page => 1, :group_id => "11252682@N00",:text => "-landscape -cityscape -sunset person", :page => i, :max_upload_date => DateTime.now.prev_month, :min_upload_date => DateTime.now.prev_month.prev_month)
              i += 1
            end

            @prompt.refcode = photo[0].url_m
            @prompt.attribution = photo[0].ownername
            @prompt.license = photo[0].license
            @prompt.attribution_url = FlickRaw.url_photopage(photo[0])
            @prompt.use_on = Date.today
            @prompt.kind = "flickr"
            @prompt.save
          end
          #@prompt = Prompt.find(@prompt)

          #@prompt = Prompt.find(:first,:order => "use_on DESC", :conditions => ["active = :active AND (use_on < :today)", {:active => true, :today => Date.today}])
        end
      end
    rescue => e
      @prompt = Prompt.random

    end

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
    @story = current_user.stories.build(params[:story])
    @story.prompt = Prompt.find(params[:story][:prompt_id])

    respond_to do |format|
      if @story.save
        format.html { redirect_to thanks_story_url(@story) }
        format.json { render json: @story, status: :created,location: @story}
      else
        @prompt = @story.prompt
        format.html { render :action => "new" }
        format.json { render json: @story.errors, status: :unprocessable_entity }
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
						format.html {
							flash[:notice] = "Emotion added"
							redirect_to story_url(@story, :anchor => "respond_emotions")
						}
            # format.js {
            #               render :update do |page|
            #                 page.replace_html 'respond_emotions', :partial => "emotions", :object => @story
            #                 page.visual_effect :highlight, 'emotions'
            #               end
            #             }
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
                @story = Story.includes(:user, :comments, :prompt, :tags, :votes).active.find(params[:id])
                @previous = Story.previous(@story).first
                @next = Story.next(@story).first
                if @story.featured
                  @next_featured = Story.next_featured(@story).first
                  @previous_featured = Story.previous_featured(@story).first
                end

    rescue Exception => e
      unless request.path.include?("featured")
        flash[:notice] = "That story doesn't exist."
      else
        flash[:notice] = "That story isn't featured."
      end
      store_location
      redirect_to recent_url

    else
        # tests to see if a following relationship exists
          following_exists(@story.user.id)

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
          @tags = Story.tag_counts_on(:genres, :limit => 100)
          @subset = "genre"
        elsif request.path.include?("emotions")
          @title = "emotions"
          @tags = Story.tag_counts_on(:emotions, :limit => 100)
          @emotions = true
          @subset = "emotion"
        else
          @title = "adjectives"
           @tags = Story.tag_counts_on(:tags, :limit => 100)
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
    @stories = Story.active.where(:prompt_id => @prompt.id).page(page).per(per_page).order(order)

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




  def disabled
      page = params[:page] || 1
      per_page = 15
      order = "updated_at DESC"

      @stories = Story.page(page).per(per_page).order(order)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stories }
    end
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

  def feature
    @story = Story.find(params[:id])
    @story.featured = 1
     respond_to do |format|
       if @story.save
         Hermes.featured_story_notification(@story.user, @story).deliver unless (@story.user.send_stories == false or @story.user.email_address.blank?)

         flash[:notice] = 'Story featured.'
         format.html { redirect_to(story_url(@story)) }
         format.xml  { head :ok }
       else
         flash[:notice] = 'Story NOT featured.'
         format.html { redirect_to(story_url(@story)) }
         format.xml  { render :xml => @story.errors, :status => :unprocessable_entity }
       end
     end
  end

  def unfeature
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




  def flag
    @story = Story.find(params[:id])
    @story.flagged += 1

     respond_to do |format|
       if @story.save
         format.html {
						redirect_to story_url(@story), notice: "Flagged story. Thank you."
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
