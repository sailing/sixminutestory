class TagsController < ApplicationController

  def show
      page = params[:page] || 1
      per_page = 20
      offset = per_page
      order = "@relevance DESC"
      @tag = params[:name]

      @stories = Story.paginate :include => :taggings, :conditions => {:tag => @tag}, :page => page, :limit => per_page, :offset => offset, :finder => "find_tagged_with"

  end
end
