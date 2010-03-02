class CommentsController < ApplicationController
    before_filter :require_user, :only => [:new, :create, :edit, :update]

  # GET /comments
  # GET /comments.xml
  def index
      page = params[:page] || 1
      per_page = 5
      condition = true
      order = "created_at DESC"
      @comments = Comment.paginate :all, :page => page, :per_page => per_page, :order => order, :conditions => {:story_id => params[:id]}
      
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @comments }
      end
      
  end

  # GET /comment/1
  # GET /comment/1.xml

  # GET /comment/new
  # GET /comment/new.xml
  def new
    @comment = Comment.new
  end

  # GET /comment/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /comment
  # POST /comment.xml
  def create
    @comment = Comment.new(params[:comment])
    @story = Story.find_by_id(@comment.story.id)
    
    respond_to do |format|
      if @comment.save
        
        Hermes.deliver_comment_notification(@story.user, @story, @comment.user, @comment) unless @story.user.send_comments == false
      
        flash[:notice] = 'Comment contributed!'
        format.html { redirect_to :controller => "stories", :action => "show", :id => @story, :anchor => "comments" }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        flash[:notice] = 'Comment is free, so give thine to me.'
        format.html { redirect_to story_path(@comment.story.id),:anchor => "comments"}
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /comment/1
  # PUT /comment/1.xml
  def update
    @comment = comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        flash[:notice] = 'comment was successfully updated.'
        format.html { redirect_to(@comment) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comment/1
  # DELETE /comment/1.xml
  def destroy
    @comment = Comment.find(params[:id])
    @story = @comment.story
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to(read_story_path(@story)) }
      format.xml  { head :ok }
    end
  end
end
