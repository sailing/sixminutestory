# Preview all emails at http://localhost:3000/rails/mailers/hermes
class HermesPreview < ActionMailer::Preview
  def branched_story_notification
    Hermes.branched_story_notification(Story.first)
  end

  def comment_notification
    Hermes.comment_notification(Comment.first)
  end

  def signup_notification
    Hermes.signup_notification(User.first)
  end

  def following_notification
    Hermes.following_notification(User.first, User.first.followers.first)
  end

  def featured_story_notification
    Hermes.featured_story_notification(Story.first)
  end
end
