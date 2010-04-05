# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
 
   def rss_feed
       if @rss_url
           content_tag 'div', (content_tag 'div', ( link_to ((image_tag "rss_22.png") + "Subscribe"), @rss_url),
                                :class => "brown button_container"), :id => "rss_feed"
       end
   end
   

    def edit_this(story = {})
      story = story ? story : @story
      if current_user && ((@user.present? && current_user.id == @user.id) || (story.present? && current_user.id == story.user_id) || (@story.present? && current_user.id == @story.user_id))
      
            link_to 'edit', edit_story_path(story)
      
      #  if @story 
       #   if current_user.id == @story.user_id
        #    link_to 'Edit', edit_story_path(@story) 
        #  end
      #  end  
      end
    
    end

    def is_user
      return true if current_user
    end
    
    def is_owner_or_admin

          if current_user && (current_user == @user || current_user.admin_level > 1 || (@story && current_user.id == @story.user_id ))
                  return true        
          end

        end

        def is_admin
            return true if current_user && current_user.admin_level > 1
        end


end
