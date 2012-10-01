module StoriesHelper
  
  def approval_rating(story)
    
    if story.votes_for > 0
        pluralize(story.votes_for, 'favorites', 'favorites')
    else
      none = "No favorites"
    end
  end
end
