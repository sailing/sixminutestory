class SiteController < ApplicationController
   before_filter :must_be_admin, :only => [:admin]


  
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
