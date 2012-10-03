$('#stories_nav').scrollspy({
	offset: 40
});

jQuery(function(){
    var storyTimer = window.SixMinute.StoryTimer.init();

	$(document).unbind('keydown').bind('keydown', function (event) {
	    var doPrevent = false;
	    if (event.keyCode === 8) {
	        var d = event.srcElement || event.target;
	        if ((d.tagName.toUpperCase() === 'INPUT' && (d.type.toUpperCase() === 'TEXT' || d.type.toUpperCase() === 'PASSWORD')) 
	             || d.tagName.toUpperCase() === 'TEXTAREA') {
	            doPrevent = d.readOnly || d.disabled;
	        }
	        else {
	            doPrevent = true;
	        }
	    }

	    if (doPrevent) {
	        event.preventDefault();
	    }
	});

	$("#new_story").submit(function (){
		$("#story_description").removeAttr("disabled");
	});

	
	$('input[type="text"]').keyup(function(){
		var value = $("#story_title").val();
	    if ( value.length > 0 && value != "Title" ) {
	    	$('input[type="submit"]').removeAttr('disabled');
	    } else {
	    	$('input[type="submit"]').attr('disabled','disabled');	
	    }
	 });
});



// Namespacing
window.SixMinute = {}
window.SixMinute.StoryTimer = {
    el:$("#timer_element")[0],
    init:function(){
		var self = this; // had to do this or startTimer was undefined
		$('input[type="submit"]').attr('disabled','disabled');
 	 	$("#story_description").focus(function(){
 	 		$("#prompt_and_timer").removeClass('hide');
 	 		$("#instructions").hide();
 	 		self.startTimer();
 	 	});
 	 	$("#done_writing").click(function(){
 	 		self.stopTimer();
 	 	});

        return this;
    },
    milliseconds: 370000,
 	// milliseconds: 4000,
    intervalId: null,
 	startTimer:function(){
	    var self = this;
	 	if(this.intervalId) {
 			clearInterval(this.intervalId);
 		}

 		self.intervalId = window.setInterval(
               function(){
                   console.log("Tick Tock");
                   self.tickTock();
               },
               1000)
 		$("#done_writing").show();
 	},
    stopTimer:function(){
        console.log("STOP TIMER!");
        clearInterval(this.intervalId);
 	
 		console.log("Focus on the title.");
 		$("#story-saved").modal('show');
 		$("#story-saved").bind('shown', function () {
  			$("#story_title").focus();
		});
		$("#story_description").attr("disabled", "disabled");
 	
    },
    updateTimerText:function(ms){
        var minutes, seconds;
        minutes = Math.floor(ms/60000);
        seconds = Math.floor((ms/1000)-(minutes*60));
        seconds+="";
        seconds.length < 2 ? seconds = "0"+seconds : seconds;
        $(this.el).text(minutes+":"+seconds);
    },
    saveStory:function(){
 	// nothing here for now
    },
    tickTock:function(){
        console.log("We're ticking!");
 		this.milliseconds -= 1000;
 		this.updateTimerText(this.milliseconds);
        console.log("One less second (" + (this.milliseconds/1000) +")");    
        
 		if(this.milliseconds > 0) {
 			
        } else {
            this.stopTimer();
        }
        
    }

}

