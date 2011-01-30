module StoriesHelper
  
  def approval_rating
    
    if @story.votes_count > 0
        pluralize(@story.votes_count, 'favorites', 'favorites')
    else
      none = "No favorites"
    end
  end
end
