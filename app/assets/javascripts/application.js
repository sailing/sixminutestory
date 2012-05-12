// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

//= require jquery
//= require jquery_ujs
//= require_self
//= require_tree .

function clearFieldFirstTime(element) {

if (element.counter==undefined) element.counter = 1;
else element.counter++;

if (element.counter == 1) element.value = '';

}


	function GetCount(iter,countDown,element) {
		
		if(1==1) {
			countDown -= 1000;
		
			if(countDown < -1) {
			} else {
				amnt = countDown;
				amnt = Math.floor(amnt/1000);
		
				mins = Math.floor(amnt/60);
				amnt = amnt%60;
		
				secs = Math.floor(amnt);
				
				if (secs<10) {
					secs = "0" + secs;
					if (mins==0 && secs==0 && iter==1) {
						iter=2;
						countDown=360000;
					} else if (mins==0 && secs==0 && iter==2) {
						
						document.getElementById('story_description').disabled=true;
					}
				}
		
			if (iter==1){
					output = "Starting in "+secs+" seconds";	
			}else{
				if (mins!==0) {
					output = "0"+mins+":"+secs;
				} else {
					if(secs<10){
						output = "0:"+secs;
					}else{
						output = "0:"+secs;
					}
				}
			}
				document.getElementById('timer_element').innerHTML = output;
		
				t=setTimeout("GetCount('"+iter+"','"+countDown+"')", 1000);
			}
			document.onkeypress=keystrokes;
			document.onkeydown=iekeystrokes;
		}
		
		//CAN ADD CODE HERE FOR AN AJAX EVENT TO FILL IN VARIOUS PARTS OF THE HTML PAGES!!
			//E.G. homepage - Title, Author, Grade, Rank, Story
			//E.G. write - prompts
			
		registerMe(4);
		document.onclick=mouseclicks;
		document.onmouseover=rollOver;
		document.onmouseout=rollOut;
		document.onchange=formChanged;
	}
	
function getSetWrite(element){
	
	if (element.focused==undefined) element.focused = 1;
	else element.focused++;

	if (element.focused == 1) {
			clearFieldFirstTime(element);
			GetCount(2,366555,element);
			
	}
	
}