class VotesController < ApplicationController
   before_save :update_rating 
  # First, figure out our nested scope. User or vote?
#  before_filter :find_my_scope
  
#  before_filter :find_user
    
#  before_filter :login_required, :only => [:new, :edit, :destroy, :create, :update]
#before_filter :must_own_vote,  :only => [:edit, :destroy, :update]


  # GET /votes/
  # GET /votes.xml
  def index
    @votes = Vote.descending

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @votes }
    end
  end

    # GET /votes/1
    # GET /votes/1.xml
    def show
      @vote = Vote.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @vote }
      end
    end

    # GET /votes/new
    # GET /votes/new.xml
    def new
      @vote = Vote.new

      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @vote }
      end
    end

    # GET /votes/1/edit
    def edit
      @vote ||= Vote.find(params[:id])
    end

    # POST /votes
    # POST /votes.xml
    def create
      @vote = Vote.new(params[:vote])
      @vote.user = current_user
      @share = Share.find_by_id(params[:share_id])

      respond_to do |format|
        if @share.votes_for > 0 
              pro = (@share.votes_for.to_f / @share.votes_count.to_f)*100
              @share.rating = pro.ceil
              @share.save
            else
                @share.rating = 0
                @share.save
            end
        end

        if @vote.save
          flash[:notice] = 'Vote was successfully saved.'
          format.html { redirect_to([@user, @vote]) }
          format.xml  { render :xml => @vote, :status => :created, :location => @vote }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @vote.errors, :status => :unprocessable_entity }
        end
      end
    end

    # PUT /votes/1
    # PUT /votes/1.xml
    def update
      @vote = Vote.find(params[:id])

      respond_to do |format|
        if @vote.update_attributes(params[:vote])
          flash[:notice] = 'Vote was successfully updated.'
          format.html { redirect_to([@user, @vote]) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @vote.errors, :status => :unprocessable_entity }
        end
      end
    end

    # DELETE /votes/1
    # DELETE /votes/1.xml
    def destroy
      @vote = Vote.find(params[:id])
      @vote.destroy

      respond_to do |format|
        format.html { redirect_to(user_votes_url) }
        format.xml  { head :ok }
      end
    end

    private
    
    def update_rating(share)
      @share = Share.find_by_id(share)
       if @share.votes_count > 0
          if @share.votes_for > 0
            pro = (@share.votes_for.to_f / @share.votes_count.to_f)*100
            @share.rating = pro.ceil
            @share.save
          else
              share.rating = 0
              share.save
          end
      end
    end
end
