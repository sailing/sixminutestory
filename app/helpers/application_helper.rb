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
          unless request.path.include?("write")   
            write_to_prompt = content_tag(:div, (link_to "Write your own story to this prompt", write_to_prompt_url(@prompt)))
            freeform = "Freeform prompt. Every Friday, writers face a blank page without any prompt. They write whatever they want in six minutes or less."
          else
            freeform = "Write as you please, <br /> in six minutes, <br /> like a breeze."
            write_to_prompt = ""
          end
          case @prompt.kind
          when "flickr"
            if @prompt.refcode.present?
            # flickr img code
            @content_tags = content_tag(:div, tag("img", { :src => @prompt.refcode }), :class => "prompt")
            	if @prompt.attribution.present? and @prompt.attribution_url.present? and @prompt.kind.present? and @prompt.license.present?
                  @content_tags << content_tag(:div, content_tag(:span, "image by <a href='#{@prompt.attribution_url}'>#{@prompt.attribution}</a> on #{@prompt.kind}. <br /> Licensed under #{@prompt.license}."), :class => "prompt")
              end
            
            
          else
            @content_tags = content_tag(:div, freeform)
          end
          when "youtube"
            #youtube embed code
            
          when "vimeo"
            #vimeo embed code
          when "quotation"
            #text w attributions
          when "firstline"
            if @prompt.refcode
              
              @content_tags = content_tag(:div, @prompt.refcode, :class => "firstline")
                
              
            else
              @content_tags = content_tag(:div, freeform)
            end
            
          when "3ww"
            #three word wednesdays??
            if @prompt.refcode
              
              @content_tags = content_tag(:div, @prompt.refcode, :class => "firstline")
                
              
            else
              @content_tags = content_tag(:div, freeform)
            end
            
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
            
            
          else
            @content_tags = content_tag(:div, freeform, :class => "entries")
            @content_tags << content_tag(:div, write_to_prompt, :class => "entries")
            
          end
            if @prompt.user_id.present?
                @content_tags << tag("br")
                @content_tags << content_tag(:div, content_tag(:span, "prompt " + " (" + (link_to "details", prompt_url(@prompt)) + ")" + " suggested by " + (link_to @prompt.user.login, profile_url(@prompt.user)) + "<br /> #{write_to_prompt}"), :class => "prompt")
             end
             content_tag(:div, @content_tags, :id => "prompt")
             
            end
      end

        def select_tag_for_filter(model, nvpairs, params)
          options = { :query => params[:query] }
          _url = url_for(eval("#{model}_url(options)"))
          #_html = %{<label for="show">Show:</label>}
          _html = %{<select name="show" id="show"}
          _html << %{onchange="window.location='#{_url}' + '?show=' + this.value">}
          nvpairs.each do |pair|
            _html << %{<option value="#{pair[:scope]}"}
            if params[:show] == pair[:scope] || ((params[:show].nil? || 
        params[:show].empty?) && pair[:scope] == "all")
              _html << %{ selected="selected"}
            end
            _html << %{>#{pair[:label]}}
            _html << %{</option>}
          end
          _html << %{</select>}
        end

end
