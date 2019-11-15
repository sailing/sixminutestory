# if request.xhr?
    #   # add the given tag to the story

    #   emotion = params[:emotion_list] || params[:story][:emotion_list]

    #   @story.emotion_list << emotion
    #   @story.save

    #   respond_to do |format|
    #     format.html {
    #      flash[:notice] = "Emotion added"
    #      redirect_to story_url(@story, :anchor => "respond_emotions")
    #     }
    #     format.js {
    #       render :update do |page|
    #         page.replace_html 'respond_emotions', :partial => "emotions", :object => @story
    #         page.visual_effect :highlight, 'emotions'
    #       end
    #     }
    #   end
    # else