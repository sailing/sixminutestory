class CommentsController < ApplicationController
    before_filter :require_user, :only => [:index, :new, :create, :edit, :update]
    before_filter :must_be_admin, :only => [:destroy]

  # GET /comments
  # GET /comments.xml
  def index
      page = params[:page] || 1
      per_page = 5
      condition = true
      order = "others_comments.created_at DESC, stories.created_at DESC"
      @user = current_user
      if params[:time]
        case params[:time]
          when "new"
            @stories = Story.active.with_unseen_comments_for_user(@user).paginate :page => page, :per_page => per_page, :order => order
            @title = "Recent comments after your comments"
          when "on"
            @stories = Story.active.new_comments_for_user_stories(@user).paginate :page => page, :per_page => per_page, :order => order
            @title = "Recent comments on your stories"
          when "allstories"
             @stories = Story.active.all_comments_for_user_stories(@user).paginate :page => page, :per_page => per_page, :order => order
             @title = "All comments on your stories"
          else
            @stories = Story.active.with_comments_for_user(@user).paginate :page => page, :per_page => per_page, :order => order
            @title = "All comments"
          end
      else 
         @stories = Story.active.with_comments_for_user(@user).paginate :page => page, :per_page => per_page, :order => order
         @title = "All comments"
      end
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
        
        Hermes.deliver_comment_notification(@story.user, @story, @comment.user, @comment) unless (@story.user.send_comments == false or @story.user.email_address.blank?) 
                
        flash[:notice] = 'Comment contributed!'
        format.html { redirect_to read_story_path(@comment.story),:anchor => "comments" }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
        format.js
      else
        flash[:notice] = 'Comment is free, so give thine to me.'
        format.html { redirect_to read_story_path(@comment.story),:anchor => "comments"}
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
