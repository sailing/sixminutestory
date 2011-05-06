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
        return true if (current_user && ((@story && current_user == @story.user) or (current_user.admin_level > 1) or (@user && current_user.id == @user.id)))
    end

    def is_admin
      return true if current_user && current_user.admin_level > 1
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
