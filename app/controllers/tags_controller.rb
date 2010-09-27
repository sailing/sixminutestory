class TagsController < ApplicationController

  def show
      page = params[:page] || 1
      per_page = 20
      order = "@relevance DESC"
      @tag = params[:tag]

      @stories = Story.tagged_with(@tag).paginate(:page => page, :limit => per_page, :order => order)

  end
end
