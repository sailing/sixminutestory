class TagsController < ApplicationController
  def index
  end
  
  def show
      page = params[:page] || 1
      per_page = 30
#      offset = page > 1 ? per_page * page : 0
      offset = per_page
      condition = true
      order = "@weight ASC created_at DESC"
      @tag_name = "*"+CGI::unescape(params[:name])+"*"
      @shares = Share.search @tag_name, :page => page, :per_page => per_page, :order => order, :match_mode => :all, :field_weights => {"tag_names" => 2, "title" =>
      1, "description" => 1, "license" => 1 }, :conditions => {:active => condition}
#      {:match => :all, :order => order, :finder => 'find_tagged_with', :page => page, :limit => per_page, :offset => offset}
    # :page => page, :per_page => per_page, :conditions => {:tag_id => params[:id]}
  end
end
