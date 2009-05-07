class CommentsController < ApplicationController
    before_filter :require_user, :only => [:new, :create, :edit, :update]

  # GET /comments
  # GET /comments.xml
  def index
      page = params[:page] || 1
      per_page = 5
      condition = true
      order = "created_at DESC"
      @comments = Comment.paginate :all, :page => page, :per_page => per_page, :order => order, :conditions => {:share_id => params[:id]}
      
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

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comment/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /comment
  # POST /comment.xml
  def create
    @comment = Comment.new(params[:comment])

    respond_to do |format|
      if @comment.save
        flash[:notice] = 'Comment was successfully created.'
        format.html { redirect_to(share_path(@comment.share_id)) }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { render :action => "new" }
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
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to(comment_url) }
      format.xml  { head :ok }
    end
  end
end
