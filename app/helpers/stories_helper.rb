module StoriesHelper
  
  def approval_rating
    if @story.votes_count > 0
      if @story.votes_for > 0
        @story.rating.to_s + "% love it"
      else
          result =  @story.votes_against.to_s + " shrugged"
      end
    else
      none = "No votes!"
    end
  end
end