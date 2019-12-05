@JSRouter.Register "stories.new", ->
	wideArea()

	window.SixMinute = {}
	window.SixMinute.StoryTimer =
		el: $("#timer_element")[0]
		init: ->
			self = this # had to do this or startTimer was undefined
			$("input[type=\"submit\"]").attr "disabled", "disabled"
			$("#story_description").focus ->
				$("#prompt_and_timer").removeClass "d-none"
				$("#instructions").addClass "d-none"
				self.startTimer()

			$("#done_writing").click ->
				self.stopTimer()

			this

		milliseconds: 370000
		intervalId: null
		startTimer: ->
			self = this
			clearInterval @intervalId  if @intervalId
			self.intervalId = window.setInterval(->
				console.log "Tick Tock"
				self.tickTock()
			, 1000)


		stopTimer: ->
			console.log "STOP TIMER!"
			clearInterval @intervalId
			console.log "Focus on the title."
			$("#story-saved").modal "show"
			$("#story-saved").bind "shown", ->
				$("#story_title").focus()

			$("#story_description").attr "disabled", "disabled"

		updateTimerText: (ms) ->
			minutes = undefined
			seconds = undefined
			minutes = Math.floor(ms / 60000)
			seconds = Math.floor((ms / 1000) - (minutes * 60))
			seconds += ""
			(if seconds.length < 2 then seconds = "0" + seconds else seconds)
			$(@el).text minutes + ":" + seconds

		saveStory: ->
			# nothing here for now
		tickTock: ->
			console.log "We're ticking!"
			@milliseconds -= 1000
			@updateTimerText @milliseconds
			console.log "One less second (" + (@milliseconds / 1000) + ")"
			@stopTimer()  unless @milliseconds > 0


	storyTimer = window.SixMinute.StoryTimer.init()
	$(document).unbind("keydown").bind "keydown", (event) ->
		doPrevent = false
		if event.keyCode is 8
			d = event.srcElement or event.target
			if (d.tagName.toUpperCase() is "INPUT" and (d.type.toUpperCase() is "TEXT" or d.type.toUpperCase() is "PASSWORD")) or d.tagName.toUpperCase() is "TEXTAREA"
				doPrevent = d.readOnly or d.disabled
			else
				doPrevent = true
		event.preventDefault()  if doPrevent

	$("#new_story").submit ->
		$("#story_description").removeAttr "disabled"

	$("input[type=\"text\"]").keyup ->
		value = $("#story_title").val()
		story_value = $("#story_description").val()

		if value.length > 0 and value isnt "Title" and story_value.length > 0 && story_value isnt "Type here to begin writing."
			$("input[type=\"submit\"]").removeAttr "disabled"
		else
			$("input[type=\"submit\"]").attr "disabled", "disabled"

	$("#story_description").keyup ->
		story_value = $("#story_description").val()

		if story_value.length > 0 && story_value isnt "Type here to begin writing."
			$("#done_writing").removeClass "d-none"
		else
			$("#done_writing").addClass "d-none"

