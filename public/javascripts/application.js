// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function clearFieldFirstTime(element) {

if (element.counter==undefined) element.counter = 1;
else element.counter++;

if (element.counter == 1) element.value = '';

}