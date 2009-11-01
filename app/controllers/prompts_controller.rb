class PromptsController < ApplicationController
  before_filter :require_user, :only => [:new,:create] 
  before_filter :must_be_admin, :only => [:enable_prompt, :disable_prompt, :verified, :edit, :update,:admin,:destroy]
 
  # GET /prompts
  # GET /prompts.xml
 
  def verified
    page = params[:page] || 1
     per_page = 15
     order = "updated_at DESC"
    
    @prompts = Prompt.paginate :page => page, :per_page => per_page, :order => order, :conditions => ["active = :active AND (use_on IS NOT :use_on)", {:active => true, :use_on => nil} ]
  
  end
  
  def verify
    page = params[:page] || 1
     per_page = 20
     order = "created_at DESC"
    
    @prompts = Prompt.paginate :page => page, :order => order, :per_page => per_page, :conditions => {:active => true, :verified => false}
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
  
  
  def past
     page = params[:page] || 1
     
       per_page = 15
       order = "use_on DESC"

      @prompts = Prompt.paginate :page => page, :order => order, :per_page => per_page, :conditions => ["active = :active AND verified = :verified AND use_on < :now", {:active => true, :verified => true, :now => Date.today} ]
    
  end

  # GET /prompts
  # GET /prompts.xml
  def admin
      page = params[:page] || 1
      per_page = 15
      order = "created_at DESC"

      @prompts = Prompt.paginate :page => page, :order => order, :per_page => per_page, :conditions => ["active = :active AND use_on IS :use_on", {:active => true, :use_on => nil} ]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @prompts }
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
