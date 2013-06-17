class TagsController < ApplicationController

  def show
      page = params[:page] || 1
      per_page = 20
      order = "@relevance DESC"
      @tag = params[:tag]

      @stories = Story.tagged_with(@tag).page(page).per(per_page).order(order)

  end
end
