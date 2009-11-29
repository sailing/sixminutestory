module StoriesHelper
  
  def approval_rating
    if @story.votes_count > 0
      if @story.votes_for > 0
        pluralize(@story.rating, 'cheer', 'cheers')
      else
          result =  @story.votes_against.to_s + " shrugged"
      end
    else
      none = "No cheers"
    end
  end
end
