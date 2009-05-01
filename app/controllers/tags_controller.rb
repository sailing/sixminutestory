class TagsController < ApplicationController
  def index
  end
  
  def show
      page = params[:page] || 1
      per_page = 5
#      offset = page > 1 ? per_page * page : 0
      offset = per_page
      condition = true
      order = "created_at DESC"
      
      @shares = Share.paginate_by_id(Share.find_tagged_with(params[:name]),:page => params[:page],:per_page => per_page, :order => order, :conditions => {:active => condition}) 
      
#      {:match => :all, :order => order, :finder => 'find_tagged_with', :page => page, :limit => per_page, :offset => offset}
    # :page => page, :per_page => per_page, :conditions => {:tag_id => params[:id]}
  end
end
