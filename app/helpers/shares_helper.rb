module SharesHelper
  
  def approval_rating
    if @share.votes_count > 0
      if @share.votes_for > 0
        pro = (@share.votes_for.to_f / @share.votes_count.to_f)*100
        pro = pro.ceil
        result = pro.to_s + "% love it"
      else
          result =  @share.votes_against.to_s + " shrugged"
      end
    else
      none = "No votes!"
    end
  end
end
