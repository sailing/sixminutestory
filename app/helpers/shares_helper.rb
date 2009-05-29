module SharesHelper
  
  def approval_rating
    if @share.votes_count > 0
      if @share.votes_for > 0
        @share.rating.to_s + "% love it"
      else
          result =  @share.votes_against.to_s + " shrugged"
      end
    else
      none = "No votes!"
    end
  end
end
