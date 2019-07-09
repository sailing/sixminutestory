class SiteController < ApplicationController
   before_action :must_be_admin, :only => [:admin]

   caches_action :index, expires_in: 1.day, layout: false

   def index
      @story_to_read = Story.featured.order("created_at DESC").first
      @active_writers_this_week = User.where("last_request_at > ?", 1.week.ago).size
      @new_stories_this_week = Story.where("created_at > ?", 1.week.ago).size
      @comments_this_week = Comment.where("created_at > ?", 1.week.ago).size

      @three_image_prompts = Prompt.where(kind: "flickr").where("refcode IS NOT NULL AND refcode != ''").where("stories_count > 1").order("created_at DESC").limit(3)

      @featured_stories = Story.featured.order("updated_at desc").limit(5)
      @recent_stories = Story.order("created_at desc").limit(5)
      @popular_stories = Story.recent(Time.now.months_ago(1)).top.limit(5)
      @active_stories = Story.recent(Time.now.months_ago(1)).commented.limit(5)
   end

	def home
		@tags = Story.tag_counts_on(:tags, :limit => 50) if current_user
		@featured = Story.featured.order("updated_at desc").first
		@top = Story.recent(Time.now.months_ago(3)).top.limit(5)
		@recent = Story.order("created_at desc").limit(5)
		@active = Story.recent(Time.now.months_ago(3)).active.limit(5)
		@authors = User.order("stories_count desc").limit(5)
		@prompts = Prompt.top.limit(5)

	end

  def browse_by_tags
    #
    @tags = Story.tag_counts_on(:tags)
    #
    @levels = (1 .. 5).map { |i| "level-#{i}" }

  end

  def search
    per_page = 30
    page = params[:page] || 1
    @q = params[:q]
    order = "@relevance DESC, created_at DESC"
    @stories = Story.search "*"+@q+"*", :page => page, :per_page => per_page, :match_mode => :all, :conditions => {:active => true}
  end

  def profile
     @user = User.find_by_login(params[:login])
     page = params[:page] || 1
     per_page = 7
     order = "created_at DESC"
     @stories = @user.stories.active.page(page).per(per_page).order(order)
     @story = @stories.first if @stories.any?
         @i = 0
   end



   def admin
     page = params[:page] || 1
     per_page = 15
     order = "flagged DESC, updated_at DESC"

     @stories = Story.paginate :page => page, :order => order, :per_page => per_page, :conditions => ["flagged >= :flagged",{:flagged => 1}]
  end
end
