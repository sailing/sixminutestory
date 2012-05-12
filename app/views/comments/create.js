if @comment
	$(#comments).append("<%= escape_javascript(render(:partial => @comment))%>");

  $("#comment_#{@comment.id.to_s}").highlight

  $(#comments_form).reset
end