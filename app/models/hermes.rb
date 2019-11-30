# encoding: utf-8
class Hermes < ActionMailer::Base

  ActionMailer::Base.default :content_type => "text/html"
  default :from => "\"Six Minute Story\" <galen@sixminutestory.com>"

  def comment_notification(writer, story, commenter, comment)
    @recipient = writer
    @story = story
    @commenter = commenter
    @comment = comment

    mail(:to => writer.email_address, :subject => "Six Minute Story – #{@commenter.login} commented on your story (#{@story.title})")
  end

  def branched_story_notification(story)
    @story = story
    @writer = @story.user

    mail(:to => @writer.email_address, :subject => "Six Minute Story – someone branched your story (#{@story.parent.title})")
  end

  def signup_notification(writer)
    @recipient = writer
    mail(:to => writer.email_address, :subject => "Six Minute Story – Welcome!")
  end

  def following_notification(writer, follower)
    @recipient = writer
    @follower = follower
    mail(:to => writer.email_address, :subject => "Six Minute Story – #{@follower.login} is now following you!")
  end
   
  def featured_story_notification(writer, story)
    @writer = writer
    @story = story
     mail(:to => writer.email_address, :subject => "Six Minute Story – Your story #{@story.title} has been featured!")
  end
   
end
