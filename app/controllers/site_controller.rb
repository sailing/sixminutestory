class SiteController < ApplicationController
   before_filter :must_be_admin, :only => [:admin]

  def index
    per_page = 1
     page = params[:page] || 1
     @q = params[:q]
     order = "updated_at DESC"
       begin

       @stories = Story.active.featured.paginate :page => page, :order => order, :per_page => per_page  
       rescue
         flash[:notice] = "There are no recent stories. \r\n Why not write your own?"
         redirect_to write_url
       else 
          respond_to do |format|
             format.html # index.html.erb
             format.xml  { render :xml => @stories }
             format.rss
           end  
       end   
  end
  
  def popular 
      per_page = 15
      page = params[:page] || 1
      @q = params[:q]
      order = "comments_count DESC, rating DESC, created_at DESC"
  
      begin

        @stories = Story.active.popular.paginate :page => page, :order => order, :per_page => per_page   
        rescue
          flash[:notice] = "There are no popular stories. Why not write your own?"
          redirect_to write_url
        else 
           respond_to do |format|
              format.html # index.html.erb
              format.xml  { render :xml => @stories }
              format.rss
            end  
        end
  
      
  end      
  
  def recent
    per_page = 15
    page = params[:page] || 1
    @q = params[:q]
    order = "created_at DESC"
#    timeThen = Time.zone.now.advance(:months => -6)
      begin
  
      @stories = Story.active.recent.paginate :page => page, :order => order, :per_page => per_page   
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
  end

  def top
    per_page = 3
    page = params[:page] || 1
    order = "rating DESC"
    begin
    @stories = Story.active.top.paginate :page => page, :order => order, :per_page => per_page   
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
    order = "@relevance DESC, created_at DESC"
    @stories = Story.search "*"+@q+"*", :page => page, :per_page => per_page, :match_mode => :all, :conditions => {:active => true}
  end
  
  def profile
     @user = User.find_by_login(params[:login])
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
