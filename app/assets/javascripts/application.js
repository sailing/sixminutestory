// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require router
//= require bootstrap
//= require_self
//= require_tree .
//= require_tree ./widearea
//= require_tree ./theme
//= require stories_index
//= require stories_new

$("a[rel=popover]").popover()
$(".tooltip").tooltip()
$("a[rel='tooltip nofollow']").tooltip()
$("[rel='tooltip']").tooltip()