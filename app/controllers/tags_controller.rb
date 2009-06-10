class TagsController < ApplicationController

  def show
      page = params[:page] || 1
      per_page = 20
#      offset = page > 1 ? per_page * page : 0
      offset = per_page
      order = "@relevance DESC"
      @tag = CGI::unescape(params[:name])

#      @shares = Share.paginate :include => :taggings, :conditions => {:tag => @tag}, :page => page, :limit => per_page, :offset => offset, :finder => "find_tagged_with"
    @shares = Share.search :page => page, :per_page => per_page, :order => order, :match_mode => :extended, :conditions => {:tag => @tag}
  end
end
