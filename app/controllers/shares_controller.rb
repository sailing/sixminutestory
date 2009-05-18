class SharesController < ApplicationController
  before_filter :require_user, :only => [:new, :create, :edit, :update, :destroy]
  
  
  # GET /shares
  # GET /shares.xml
  def index
    page = params[:page] || 1
    per_page = 20
    order = "created_at DESC"
    @shares = Share.paginate :page => page, :order => order, :per_page => per_page, :conditions => {:active => true}    
    
    

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @shares }
    end
  end

  # GET /shares/1
  # GET /shares/1.xml
  def show
    @share = Share.find(params[:id], :conditions => {:active => true}, :include => :tags)
    @comment = Comment.new
    
    # Comments
    page = params[:page] || 1
    per_page = 10
    condition = true
    order = "created_at DESC"
    @comments = Comment.paginate :all, :page => page, :per_page => per_page, :order => order, :conditions => {:share_id => params[:id]}
      
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @share }
    end
  end

  # GET /shares/new
  # GET /shares/new.xml
  def new
    @share = Share.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @share }
    end
  end

  # GET /shares/1/edit
  def edit
    @share = Share.find(params[:id])
  end

  # POST /shares
  # POST /shares.xml
  def create
    @share = Share.new(params[:share])

    respond_to do |format|
      if @share.save
        @user = @current_user
        @share.update_attribute("user_id", @user.id)
        format.html { redirect_to(@share) }
        format.xml  { render :xml => @share, :status => :created, :location => @share }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @share.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /shares/1
  # PUT /shares/1.xml
  def update
    @share = Share.find(params[:id])

    respond_to do |format|
      if @share.update_attributes(params[:share])
        format.html { redirect_to(@share) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @share.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /shares/1
  # DELETE /shares/1.xml
  def destroy
    @share = Share.find(params[:id])
    @share.active = false
    @share.save

    respond_to do |format|
      format.html { redirect_to(shares_url) }
      format.xml  { head :ok }
    end
  end
  
  def search
    per_page = 30
    page = params[:page] || 1
    order = "created_at DESC"
    @q = params[:q]
    @shares = Share.search @q, :page => page, :per_page => per_page, :match_mode => :all, :order => order, :conditions => {:active => true}
  end
  
  private
  
  def get_description
    if(request.xhr?)
      description = find.first()
      render :text => description
    end
  end
  
 

end
