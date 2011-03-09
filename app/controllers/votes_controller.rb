class VotesController < ApplicationController
 
   
  # First, figure out our nested scope. User or Story? Important for presenting lists
  before_filter :find_votes_for_my_scope, :only => [:index]
     
  before_filter :require_user, :only => [:index, :new, :edit, :destroy, :create, :update]
  before_filter :must_own_vote,  :only => [:edit, :destroy, :update]
  after_filter :increment_votes_count, :only => [:create]
  # before_filter :update_rating, :only => [:create,:destroy]
#  before_filter :not_allowed,    :only => [:edit, :update, :new]

  # GET /users/:user_id/stories/
  # GET /users/:user_id/stories.xml
  # GET /users/:user_id/stories/:quote_id/votes/
  # GET /users/:user_id/stories/:quote_id/votes.xml
  def index
    @user = User.find(params[:user]) || current_user
 
    page = params[:page] || 1
    per_page = params[:per_page] || 10

    if params[:order]
      case params[:order]
        when /^popular/
          order = "counter DESC"
        when /^most/
          order = "rating DESC"
        when /^recent/
          order = "votes.created_at DESC"
        when /^earliest/
          order = "votes.created_at ASC"
      else
        order = "votes.created_at DESC"
      end
    end
    
    order = order || "votes.created_at DESC"
    
    
#    @stories = Story.find_by_sql(["select stories.* from stories, votes where votes.voter_id = ? AND stories.id = votes.voteable_id", @user]).paginate :per_page => 3, :page => page
  @stories = Story.find(:all, :include => :votes, :conditions => ["votes.voter_id = ? AND stories.id = votes.voteable_id", @user], :order => order).paginate :per_page => per_page, :page => page
 #   @stories = Story.favorites
  #  @stories.paginate :per_page => 3, :page => page
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @votes }
    end
  end

  # GET /users/:user_id/votes/1
  # GET /users/:user_id/votes/1.xml
  # GET /users/:user_id/votes/:quote_id/votes/1
  # GET /users/:user_id/votes/:quote_id/1.xml
  def show
    @story = Vote.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vote }
    end
  end

  # GET /users/:id/stories/new      # INVALID
  # GET /users/:id/stories/new.xml  # INVALID
  # GET /users/:id/stories/new      # INVALID
  # GET /users/:id/stories/new.xml  # INVALID
  def new
  end

  # GET /users/:id/votes/1/edit
  def edit
  end

  # POST /stories/:story_id/votes
  # POST /stories/:vote_id/votes.xml
  def create
    @voteable = find_voteable
    
    respond_to do |format|
    if params[:vote_direction]

        if current_user.vote(@voteable, :direction => params[:vote_direction], :exclusive => true)
          @voteable.reload
            format.html {redirect_to @voteable}
            format.js
        else
            format.html { render :action => "new" }
            format.js  { render :action => "error" }
        end
    
      else
        flash[:notice] = "Please don't attempt to adjust favorites manually."
        redirect_to @voteable
      end  
    end
  end

  # PUT /users/:id/votes/1
  # PUT /users/:id/votes/1.xml
  def update
  end
  
  # DELETE /users/:id/votes/1
  # DELETE /users/:id/votes/1.xml
  def destroy
    @vote = Vote.find(params[:id])
    @vote.destroy

    respond_to do |format|
      format.html { redirect_to(user_votes_url) }
      format.xml  { head :ok }
    end
  end

  private
  def find_votes_for_my_scope
    if params[:story_id]
      @votes = Vote.for_voteable(Story.find(params[:story_id])).descending
    elsif params[:user_id]
      @votes = Vote.for_voter(User.find(params[:user_id])).descending         
    else  
      @votes = []
    end
  end

  def must_own_vote
    @vote ||= Vote.find(params[:id])
    @vote.user == current_user || ownership_violation
  end

  def ownership_violation
    respond_to do |format|
      flash[:notice] = 'You cannot edit or delete vote that you do not own!'
      format.html do
        redirect_to user_path(current_user)
      end
    end
  end

  def increment_votes_count
   if @voteable && params[:vote_direction]
     # increment votes_count
      if params[:vote_direction] == "up"
        @voteable.class.name.constantize.increment_counter(:votes_count, @voteable)
      elsif params[:vote_direction] == "down"
        @voteable.class.name.constantize.decrement_counter(:votes_count, @voteable)
      end
   end
  end
  
  def find_voteable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end

end
