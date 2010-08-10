class PromptsController < ApplicationController
  before_filter :require_user, :only => [:new,:create] 
  before_filter :must_be_admin, :only => [:enable_prompt, :disable_prompt, :verified, :edit, :update,:admin,:destroy]
 
  # GET /prompts
  # GET /prompts.xml
 
  # GET /prompts
  # GET /prompts.xml
  def index
      page = params[:page] || 1
      page_i = params[:page_i] || 1
      per_page = 10
      order = "created_at DESC"
      
      @filters = Prompt::FILTERS
    if params[:show] && params[:show] != "verified" && @filters.collect{|f| f[:scope]}.include?(params[:show])
          @prompts = Prompt.verified.send(params[:show]).paginate :page => page, :per_page => per_page, :order => order
          @table = params[:show]
    else
        
      begin
        case request.path
          when /^\/prompts\/unverified/
            @images = Prompt.unverified.images.paginate :page => page_i, :per_page => per_page, :order => order
            @hvg = Prompt.unverified.hvg.paginate :page => page, :per_page => per_page, :order => order
            
        else
            @images = Prompt.verified.images.paginate :page => page_i, :per_page => per_page, :order => order
            @hvg = Prompt.verified.hvg.paginate :page => page, :per_page => per_page, :order => order
        end
          
      rescue
         flash[:notice] = "There are no stories. Why not write your own?"
        redirect_to write_url
      else 
        respond_to do |format|
          format.html # index.html.erb
          format.xml  { render :xml => @stories }
          format.rss
        end 
        #end respond_to
      end
      #end begin
    end
    #end if params[:show]  
  end
    
  def enable_prompt
    @prompt = Prompt.find(params[:id])
    @prompt.active = 1
     respond_to do |format|
       if @prompt.save
         flash[:notice] = 'Prompt verified.'
         format.html { redirect_to(prompts_admin_path) }
         format.xml  { head :ok }
       else
         flash[:notice] = 'Prompt NOT verified.'
         format.html { redirect_to(prompts_admin_path) }
         format.xml  { render :xml => @prompt.errors, :status => :unprocessable_entity }
       end
     end
  end
  
  def disable_prompt
    @prompt = Prompt.find(params[:id])
    @prompt.active = 0
     respond_to do |format|
       if @prompt.save
         flash[:notice] = 'Prompt verified.'
         format.html { redirect_to(prompts_admin_path) }
         format.xml  { head :ok }
       else
         flash[:notice] = 'Prompt NOT verified.'
         format.html { redirect_to(prompts_admin_path) }
         format.xml  { render :xml => @prompt.errors, :status => :unprocessable_entity }
       end
     end
  end


  # GET /prompts/1
  # GET /prompts/1.xml
  def show
    @prompt = Prompt.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @prompt }
    end
  end

  # GET /prompts/new
  # GET /prompts/new.xml
  def new
    @prompt = Prompt.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @prompt }
    end
  end

  # GET /prompts/1/edit
  def edit
    @prompt = Prompt.find(params[:id])
  end

  # POST /prompts
  # POST /prompts.xml
  def create
    @prompt = Prompt.new(params[:prompt])
    @prompt.user_id = current_user.id
      
      if @prompt.kind.blank? 
        @prompt.kind = "hvg"
      end
      
    respond_to do |format|
      if @prompt.save
        flash[:notice] = 'Thanks! We received your suggestion and will review it soon.'
        format.html { redirect_to(new_prompt_url) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @prompt.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /prompts/1
  # PUT /prompts/1.xml
  def update
    @prompt = Prompt.find(params[:id])
    
    respond_to do |format|
      if @prompt.save && @prompt.update_attributes(params[:prompt])
        flash[:notice] = 'Prompt was successfully updated.'
        format.html { redirect_to(@prompt) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @prompt.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /prompts/1
  # DELETE /prompts/1.xml


  def random
    e = ActiveRecord::RecordNotFound
    begin
      get_random()
    rescue Exception => e
      redirect_to write_random_url
    else
      redirect_to write_to_prompt_url(@prompt)
      
    end
      
  end


end
