# encoding: utf-8
class Hermes < ActionMailer::Base

  ActionMailer::Base.default :content_type => "text/html"
  default :from => "\"Six Minute Story\" <galen@sixminutestory.com>"

  def comment_notification(comment)
    @comment = comment
    @commenter = @comment.user
    @story = @comment.story
    @recipient = @story.user

    mail(:to => @recipient.email, :subject => "Six Minute Story – #{@commenter.login} commented on your story (#{@story.title})")
  end

  def branched_story_notification(story)
    @story = story
    @writer = @story.user
    @parent = @story.parent
    @recipient = @parent.user

    mail(:to => @recipient.email, :subject => "Six Minute Story – #{@writer.login rescue 'Someone'} branched your story (#{@parent.title})")
  end

  def signup_notification(writer)
    @recipient = writer
    mail(:to => @recipient.email, :subject => "Six Minute Story – Welcome!")
  end

  def following_notification(writer, follower)
    @recipient = writer
    @follower = follower
    mail(:to => @recipient.email, :subject => "Six Minute Story – #{@follower.login} is now following you!")
  end
   
  def featured_story_notification(story)
    @story = story
    @recipient = @story.user
    mail(:to => @recipient.email, :subject => "Six Minute Story – Your story #{@story.title} has been featured!")
  end
   
end
