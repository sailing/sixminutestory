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
        
        
        def show_prompt
          if @prompt
          case @prompt.kind
          when "flickr"
            # flickr img code
            @content_tags = content_tag(:div, tag("img", { :src => @prompt.refcode }), :class => "prompt")
             @content_tags << content_tag(:div, content_tag(:span, "image by <a href='#{@prompt.attribution_url}'>#{@prompt.attribution}</a> on #{@prompt.kind}. Licensed under #{@prompt.license}."), :class => "prompt")
            @content_tags
          when @prompt.kind == "youtube"
            #youtube embed code

          when "vimeo"
            #vimeo embed code
          when "quotation"
            #text w attributions
          when "hvg"
            # hero villain goal
            @content_tags = content_tag(:span, "hero", :class => "labels") 
            @content_tags << content_tag(:span, (h @prompt.hero), :class => "entries")
            @content_tags << tag("br")
            @content_tags << content_tag(:span, "villain", :class => "labels")
            @content_tags <<   content_tag(:span, (h @prompt.villain), :class => "entries")
            @content_tags <<   tag("br")
            @content_tags << content_tag(:span, "goal", :class => "labels") 
            @content_tags <<   content_tag(:span, (h @prompt.goal), :class => "entries")
            @content_tags <<   tag("br")
            content_tag(
            :div, (
                @content_tags
                  ), 
            :id => "prompt")

          else
            content_tag(:p, "Write as you please, in six minutes, like a breeze.")
          end
      
        end
        end

end
