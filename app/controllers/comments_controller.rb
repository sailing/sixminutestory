class CommentsController < ApplicationController
  before_action :authenticate_user!, :only => [:index, :new, :create]
  before_action :must_be_admin, :only => [:destroy, :edit, :update]

  # GET /comments
  # GET /comments.xml
  def index
      page = params[:page] || 1
      per_page = 5
      condition = true
      order = "stories.updated_at DESC"
      @user = current_user

        if params[:time]
          case params[:time]
            when "new"
              @stories = Story.with_unseen_comments_for_user(@user).page(page).per(per_page).order(order)
              @title = "New comments after your comments"
            when "on"
              @stories = Story.new_comments_for_user_stories(@user).page(page).per(per_page).order(order)
              @title = "New comments on your stories"
            when "allstories"
               @stories = Story.all_comments_for_user_stories(@user).page(page).per(per_page).order(order)
               @title = "All comments on your stories"
            else
              @stories = Story.with_comments_for_user(@user).page(page).per(per_page).order(order)
              @title = "All comments after your comments"
            end
        else
           @stories = Story.with_comments_for_user(@user).page(page).per(per_page).order(order)
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
    @story = Story.find(params[:story_id])
    @comment = @story.comments.build(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save

        Hermes.comment_notification(@story.user, @story, @comment.user, @comment).deliver unless (@story.user.send_comments == false or @story.user.email_address.blank?)

				flash[:notice] = "Thank you for your comment!"
        format.html { redirect_to story_url(@comment.story, :anchor => "comments") }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        flash[:notice] = 'Comment is free, so give thine to me.'
        format.html { redirect_to story_url(@comment.story),:anchor => "comments"}
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
      format.html { redirect_to(story_url(@story)) }
      format.xml  { head :ok }
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:comment, :story_id)
    end
end
