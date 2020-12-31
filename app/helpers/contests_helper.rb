module ContestsHelper
  def starts_at_in_words(contest)
    (contest.duration.first + 1.second).strftime("%B %d, %Y %l:%M%P")
  end

  def ends_at_in_words(contest)
    (contest.duration.last - 1.second).strftime("%B %d, %Y %l:%M%P")
  end
end
