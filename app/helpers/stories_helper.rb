module StoriesHelper
  
  def approval_rating
    if @story.votes_count > 0
        pluralize(@story.rating, 'favorites', 'favorites')
    else
      none = "No favorites"
    end
  end
end
