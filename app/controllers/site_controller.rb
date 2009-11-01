class SiteController < ApplicationController
   before_filter :must_be_admin, :only => [:admin]

  def index
    per_page = 15
    page = params[:page] || 1
    @q = params[:q]
    order = "created_at DESC"
    timeThen = Time.now.advance(:years => -1)
   @stories = Story.search(
            :page => page, 
            :per_page => per_page, 
            :order => order, 
            :match_mode => :all, 
            :conditions =>{
              :active => true, 
              :updated_at => timeThen..Time.now 
            })
               
   #  @stories = Story.paginate :page => page, :order => order, :per_page => per_page, :conditions => {:active => true}   

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stories }
      format.rss
    end
  end

  def recent
    per_page = 15
    page = params[:page] || 1
    @q = params[:q]
    order = "created_at DESC"
    timeThen = Time.now.advance(:months => -1)
      begin
         @stories = Story.search(
            :page => page, 
            :per_page => per_page, 
            :order => order, 
            :match_mode => :all, 
            :conditions =>{
              :active => true, 
              :created_at => timeThen..Time.now 
              }
          )
    #  @stories = Story.paginate :page => page, :order => order, :per_page => per_page, :conditions => {:active => true, :created_at => }   
      rescue
        flash[:notice] = "There are no recent stories. Why not write your own?"
        redirect_to write_url
      else 
         respond_to do |format|
            format.html # index.html.erb
            format.xml  { render :xml => @stories }
            format.rss
          end  
      end
               
   #  @stories = Story.paginate :page => page, :order => order, :per_page => per_page, :conditions => {:active => true}   

   end

  def top
    per_page = 5
    page = params[:page] || 1
    value = 1    
    @stories = Story.tally(
      {   :at_least => 1, 
          :at_most => 10000,  
          :start_at => 1.year.ago,
          :end_at => Time.now,
          :limit => 20,
          :order => "stories.rating DESC",
          :conditions => ["stories.active = ? AND votes.vote  = ?", true, true]
      }).paginate(:per_page => per_page, :page => page)
      
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stories }
      format.rss
    end
  end
  
  def browse_by_tags 
    #
    @tags = Story.tag_counts
    #
    @levels = (1 .. 5).map { |i| "level-#{i}" }
  
  end
  
  def search
    per_page = 30
    page = params[:page] || 1
    @q = params[:q]
    order = "@relevance DESC"
    @stories = Story.search @q, :page => page, :per_page => per_page, :match_mode => :all, :conditions => {:active => true}
  end
  
  def profile
     @user = User.find_by_login params[:login]
     page = params[:page] || 1
     per_page = 7
     order = "created_at DESC"
     @stories = Story.paginate_by_user_id @user.id, :page => page, :order => order, :per_page => per_page, :conditions => {:active => true}    

         @i = 0
   end
   
   
   
   def admin
     page = params[:page] || 1
     per_page = 15
     order = "flagged DESC, updated_at DESC"
     
     @stories = Story.paginate :page => page, :order => order, :per_page => per_page, :conditions => ["flagged >= :flagged",{:flagged => 1}]
  end 
end
