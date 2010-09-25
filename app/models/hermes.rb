class Hermes < ActionMailer::Base

  ActionMailer::Base.default_url_options[:host] = "sixminutestory.com"
  ActionMailer::Base.default_content_type = "text/html"

  def comment_notification(writer, story, commenter, comment)
     from "\"Six Minute Story\" <no-reply@sixminutestory.com>"
     recipients writer.email_address
     subject "Six Minute Story – #{commenter.login} commented on your story \"#{story.title}\""
     body :recipient => writer, :story => story, :commenter => commenter, :comment => comment
   end
   
   def signup_notification(recipient)
     from "\"Six Minute Story\" <no-reply@sixminutestory.com>"
       recipients recipient.email_address
       subject "Six Minute Story – Welcome!"
       body :recipient => recipient
   end
   
   def following_notification(writer, follower)
     from "\"Six Minute Story\" <no-reply@sixminutestory.com>"
      recipients writer.email_address
      subject "Six Minute Story – #{follower.login} is now following you!"
      body :recipient => writer, :follower => follower
   end
   
   def featured_story_notification(writer, story)
      from "\"Six Minute Story\" <no-reply@sixminutestory.com>"
       recipients writer.email_address
       subject "Six Minute Story – Your story #{story.title} has been featured!"
       body :writer => writer, :story => story
    end
   
  def new_story_notification(followers, story, writer)
    from "\"Six Minute Story\" <no-reply@sixminutestory.com>"
     recipients "no-reply@sixminutestory.com"
     bcc followers
     subject "Six Minute Story – #{writer.login} has written a new story!"
     body :story => story, :writer => writer
  end
end
