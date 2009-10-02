class PromptsController < ApplicationController
  before_filter :require_user, :only => [:new,:create] 
  before_filter :must_be_admin, :only => [:verify_prompt, :verified, :edit, :update,:admin,:destroy]
 
  # GET /prompts
  # GET /prompts.xml
 
  def verified
    page = params[:page] || 1
    today_per_page = 100
     per_page = 15
     order = "start ASC"
      today = DateTime.now.advance(:hours => -12).strftime("%Y%m%d")
    
    @prompts = Prompt.all(:order => order,:conditions => ["active = :active AND verified = :verified AND (end > :now OR start > :now)", {:active => true, :verified => true, :now => Time.zone.now.advance(:hours => -12)} ])
  
  end
  
  def verify
    page = params[:page] || 1
     per_page = 20
     order = "created_at DESC"
    
    @prompts = Prompt.paginate :page => page, :order => order, :per_page => per_page, :conditions => {:active => true, :verified => false}
  end
  
  def verify_prompt
    @prompt = Prompt.find(params[:id])
    @prompt.verified = 1
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
    @prompts = Prompt.all

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

    respond_to do |format|
      if @prompt.save
        flash[:notice] = 'Prompt was successfully created.'
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
    @prompt.use_on = Date.new(params[:date]['year'].to_i,params[:date]['month'].to_i,params[:date]['day'].to_i)

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
  def destroy
    @prompt = Prompt.find(params[:id])
    @prompt.destroy

    respond_to do |format|
      format.html { redirect_to(prompts_url) }
      format.xml  { head :ok }
    end
  end
end
