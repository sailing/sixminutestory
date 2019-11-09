class PromptsController < ApplicationController
  before_action :authenticate_user!, :only => [:new, :create] 
  before_action :must_be_admin, :only => [:enable_prompt, :disable_prompt, :verified, :edit, :update,:admin,:destroy]
 
  # GET /prompts
  # GET /prompts.xml
 
  # GET /prompts
  # GET /prompts.xml
  def index
      page = params[:page] || 1
      per_page = 10
      order = "created_at DESC"
      
      @filters = Prompt::FILTERS
    if params[:show] && params[:show] != "verified" && @filters.collect{|f| f[:scope]}.include?(params[:show])
          if params[:subset] == "unverified"
                @prompts = Prompt.unverified.send(params[:show]).page(page).per(per_page).order(order)
          else
                @prompts = Prompt.verified.send(params[:show]).page(page).per(per_page).order(order)
          end
                @table = params[:show]
    else
      case request.path
        when /^\/prompts\/unverified/
          if params[:show] && params[:show] != "verified" && @filters.collect{|f| f[:scope]}.include?(params[:show])
            @prompts = Prompt.unverified.send(params[:show]).page(page).per(per_page).order(order)
            @table = params[:show]
          else
            @prompts = Prompt.unverified.firstlines.page(page).per(per_page).order(order)
            @table = "firstlines"
          end
        when /^\/prompts\/scheduled/
            @prompts = Prompt.active.usable.order("use_on ASC").page(page)
            @scheduled = true              
      else

            @prompts = Prompt.active.verified.firstlines.page(page).per(per_page).order(order)
      end
    end
    
        respond_to do |format|
          format.html # index.html.erb
          format.xml  { render :xml => @stories }
          format.rss
        end 

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
  
  def destroy
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
    page = params[:page] || 1
    order = "created_at DESC"
    per_page = 10
    @stories = Story.active.where(:prompt_id => @prompt.id).order(order).page(page).per(per_page)

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
    @prompt = Prompt.new(prompt_params)
    @prompt.user_id = current_user.id
      
      if params[:prompt][:flickr]
        @prompt.kind = "flickr" 
      elsif params[:prompt][:startline]
        @prompt.kind = "firstline" 
      # 3ww??
    	elsif params[:prompt][:hvg]
        @prompt.kind = "hvg"
      else
				@prompt.kind = nil
			end
      
    respond_to do |format|
      if @prompt.save
        flash[:notice] = 'Thanks! We received your suggestion and will review it soon.'
        format.html { redirect_to(suggest_prompts_url) }
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
      if @prompt.update_attributes(prompt_params)
        flash[:notice] = 'Prompt was successfully updated.'
        format.html { redirect_to(@prompt) }
        format.xml  { head :ok }
      else
        flash[:warning] = 'Prompt failed to update.'
        format.html { render :action => "edit" }
        format.xml  { render :xml => @prompt.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /prompts/1
  # DELETE /prompts/1.xml


  def random
    @prompt = Prompt.random
    redirect_to write_to_prompt_url(@prompt)
  end

  def destroy
     @prompt = Prompt.find(params[:id])
     @prompt.active = 0
      respond_to do |format|
        if @prompt.save
          flash[:notice] = 'Prompt hidden.'
          format.html { redirect_to(prompts_path) }
          format.xml  { head :ok }
        else
          flash[:notice] = 'Prompt NOT hidden.'
          format.html { redirect_to(prompts_path) }
          format.xml  { render :xml => @prompt.errors, :status => :unprocessable_entity }
        end
      end
   end

   private
    def prompt_params
      params.require(:prompt).permit(:hero,:villain,:goal,:refcode,:kind)
    end

end

class FavoritePromptsController < ApplicationController
  require_dependency 'prompt'
end
