# encoding: utf-8
class Hermes < ActionMailer::Base

  ActionMailer::Base.default :content_type => "text/html"
  default :from => "\"Six Minute Story\" <galen@sixminutestory.com>"

  def comment_notification(comment)
    @comment = comment
    @commenter = @comment.user
    @story = @comment.story
    @recipient = @story.user

    # Set tags in mailgun
    headers["X-Mailgun-Tag"] = "New Comment"
    # Variables for mail send. This needs to be JSON
    headers["X-Mailgun-Variables"] = {
      "story_id": @story.id,
      "recipient": @recipient.login,
      "comment_id": @comment.id,
      "commenter": @commenter.login
    }

    mail(:to => @recipient.email, :subject => "Six Minute Story – #{@commenter.login} commented on your story (#{@story.title})")
  end

  def branched_story_notification(story)
    @story = story
    @writer = @story.user
    @parent = @story.parent
    @recipient = @parent.user

    # Set tags in mailgun
    headers["X-Mailgun-Tag"] = "Branched Story"
    # Variables for mail send. This needs to be JSON
    headers["X-Mailgun-Variables"] = {
      "story_id": @story.id,
      "parent_id": @parent.id,
      "writer": @writer.login
    }

    mail(:to => @recipient.email, :subject => "Six Minute Story – #{@writer.login rescue 'Someone'} branched your story (#{@parent.title})")
  end

  def signup_notification(writer)
    @recipient = writer
    mail(:to => @recipient.email, :subject => "Six Minute Story – Welcome!")
  end

  def following_notification(writer, follower)
    @recipient = writer
    @follower = follower

    # Set tags in mailgun
    headers["X-Mailgun-Tag"] = "New Follower"
    # Variables for mail send. This needs to be JSON
    headers["X-Mailgun-Variables"] = {
      "recipient": @recipient.login,
      "follower": @follower.login
    }

    mail(:to => @recipient.email, :subject => "Six Minute Story – #{@follower.login} is now following you!")
  end
   
  def featured_story_notification(story)
    @story = story
    @recipient = @story.user

    # Set tags in mailgun
    headers["X-Mailgun-Tag"] = "Featured Story"
    # Variables for mail send. This needs to be JSON
    headers["X-Mailgun-Variables"] = {
      "recipient": @recipient.login,
      "story_id": @story.id
    }

    mail(:to => @recipient.email, :subject => "Six Minute Story – Your story #{@story.title} has been featured!")
  end

  def tenth_anniversary_email(recipient, serialized_story = nil, branchable_story = nil)
    @recipient = recipient

    @serialized_story = serialized_story || Story.find(3480) # DrMikeReddy's serialized story
    @serialized_story_2 = serialized_story || Story.find(1306) # TimSevenhuysen's serialized story
    @branchable_story = branchable_story || Story.find(3315) # TonyNoland's great option|| 2675-corner-john || 2648-the-newcomers

    # Set tags in mailgun
    headers["X-Mailgun-Tag"] = "Tenth Anniversary Email"
    # Variables for mail send. This needs to be JSON
    headers["X-Mailgun-Variables"] = {
      "recipient": @recipient.login
    }

    mail(:to => @recipient.email, :subject => "Six Minute Story – Ten Years In, We're back!")
  end
end
