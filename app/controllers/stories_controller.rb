class StoriesController < ApplicationController
  before_action :set_story, only: [:show, :edit, :update, :destroy]

  # GET /stories
  def index
    @stories = Story.all
  end

  # GET /stories/1
  def show
  end

  # GET /stories/new
  def new
    @story = Story.new
  end

  # GET /stories/1/edit
  def edit
  end

  # POST /stories
  def create
    @story = Story.new(story_params)

    # establish that this is a legit prompt by loading it
    @prompt = Prompt.find(params[:prompt_id])

    if params[:parent_story_id]
      @parent_story = Story.find(params[:parent_story_id])
      @story.parent = @parent_story if @parent_story
    end

    @story.prompt = @prompt
    
    if @story.save
      redirect_to @story, notice: 'Story was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /stories/1
  def update
    if @story.update(story_params)
      redirect_to @story, notice: 'Story was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /stories/1
  def destroy
    @story.destroy
    redirect_to stories_url, notice: 'Story was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_story
      @story = Story.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def story_params
      params.require(:story).permit(:title, :description, :license)
    end
end
