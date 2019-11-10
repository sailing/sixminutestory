class VotesController < ApplicationController 
   
  # First, figure out our nested scope. User or Story? Important for presenting lists
  before_action :find_votes_for_my_scope, :only => [:index]
     
  before_action :authenticate_user!, :only => [:index, :new, :edit, :destroy, :create, :update]
  before_action :must_own_vote,  :only => [:edit, :destroy, :update]
  after_action :increment_votes_count, :only => [:create]
  # before_action :update_rating, :only => [:create,:destroy]
#  before_action :not_allowed,    :only => [:edit, :update, :new]

  # GET /users/:user_id/stories/
  # GET /users/:user_id/stories.xml
  # GET /users/:user_id/stories/:quote_id/votes/
  # GET /users/:user_id/stories/:quote_id/votes.xml
  def index
    @user = params[:user].present? ? User.find(params[:user]) : current_user

    page = params[:page] || 1
    per_page = params[:per_page] || 10

    if params[:order]
      case params[:order]
        when /^popular/
          order = "counter DESC"
        when /^most/
          order = "votes_count DESC"
        when /^recent/
          order = "votes.created_at DESC"
        when /^earliest/
          order = "votes.created_at ASC"
      else
        order = "votes.created_at DESC"
      end
    end
    
    order = order || "votes.created_at DESC"
    
    
    #  @stories = Story.find_by_sql(["select stories.* from stories, votes where votes.voter_id = ? AND stories.id = votes.voteable_id", @user]).paginate :per_page => 3, :page => page
    @stories = Story.includes(:votes).joins(:votes).having("votes.voter_id = ?", @user.id).having("stories.id = votes.voteable_id").group("stories.id, votes.id").page(page).per(per_page).order(order)
    #  @stories = Story.favorites
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
				if @voteable.voted_by?(current_user)
					if current_user.voted_for?(@voteable)
						@decrement_rating = true
						@times = 2
					else
						@times = 2
						@increment_rating = true
					end
				else 
					@times = 1
					@decrement_rating = true
					@increment_rating = true
				end
        
        if current_user.vote(@voteable, :direction => params[:vote_direction], :exclusive => true)
          @voteable.reload
          format.html {redirect_to @voteable}
          format.js
        else
            format.html { redirect_to @voteable, notice: "Favorite not saved." }
            format.js  { render :action => "error" }
        end
    
      else
        flash[:notice] = "Please don't attempt to adjust favorites manually."
        redirect_to @voteable
      end  
    end
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
			case @voteable.class.name
				when "Story"
					@times = 1
			end
     # increment votes_count
      if params[:vote_direction] == "up"
				if @increment_rating
        	@times.times do
						if @voteable.class.name.constantize.increment_counter(:votes_count, @voteable)
							User.increment_counter(:reputation,@voteable.user) if @voteable.user
						end
					end
				end
      elsif params[:vote_direction] == "down"
        if @decrement_rating
					@times.times do
						if @voteable.class.name.constantize.decrement_counter(:votes_count, @voteable)
							User.decrement_counter(:reputation,@voteable.user) if @voteable.user
						end
					end
				end
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
