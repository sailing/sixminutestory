class PromptsController < ApplicationController
  before_action :set_prompt, only: [:show, :edit, :update, :destroy]

  # GET /prompts
  def index
    @prompts = Prompt.all
  end

  # GET /prompts/1
  def show
  end

  # GET /prompts/new
  def new
    @prompt = Prompt.new
  end

  # GET /prompts/1/edit
  def edit
  end

  # POST /prompts
  def create
    @prompt = Prompt.new(prompt_params)
    @prompt.kind = "firstline"
    @prompt.verified = true
    
    if @prompt.save
      redirect_to @prompt, notice: 'Prompt was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /prompts/1
  def update
    if @prompt.update(prompt_params)
      redirect_to @prompt, notice: 'Prompt was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /prompts/1
  def destroy
    @prompt.destroy
    redirect_to prompts_url, notice: 'Prompt was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prompt
      @prompt = Prompt.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def prompt_params
      params.require(:prompt).permit(:firstline, :active)
    end
end
