jQuery(function(){
    var storyTimer = window.SixMinute.StoryTimer.init();
})

// Namespacing
window.SixMinute = {}
window.SixMinute.StoryTimer = {
    el:$("#timer_element")[0],
    init:function(){
		var self = this; // had to do this or startTimer was undefined
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
 	},
    stopTimer:function(){
        console.log("STOP TIMER!");
        clearInterval(this.intervalId);
 	
 		console.log("Focus on the title.");
 		$("#story-saved").modal('show');
 		$("#story-saved").bind('shown', function () {
  			$("#story_title").focus();
		});
 	
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