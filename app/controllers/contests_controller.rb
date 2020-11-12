class ContestsController < ApplicationController
  before_action :set_contest, only: [:show, :edit, :update, :destroy]
  before_action :must_be_admin, :only => [:index, :new, :edit, :create, :update, :destroy]

  # GET /contests
  def index
    @contests = Contest.all
  end

  # GET /contests/1
  def show
  end

  # GET /contests/new
  def new
    @contest = Contest.new
  end

  # GET /contests/1/edit
  def edit
  end

  # POST /contests
  def create
    @contest = Contest.new(contest_params)

    if @contest.save
      redirect_to @contest, notice: 'Contest was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /contests/1
  def update
    if @contest.update(contest_params)
      redirect_to @contest, notice: 'Contest was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /contests/1
  def destroy
    @contest.destroy
    redirect_to contests_url, notice: 'Contest was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contest
      @contest = Contest.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def contest_params
      params.require(:contest).permit(:title, :description, :allow_multiple_entries, :terms, :prompt_id, :user_id, :duration, :approved)
    end
end
