module CommentsHelper

  def comment_rating
    
    if comment.votes_for > 0
        pluralize(comment.votes_for, 'agrees', 'agree')
    else
      none = "None agree"
    end
  end


end
