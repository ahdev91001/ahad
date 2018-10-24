// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
// Craziest thing with bootstrap!!?!?!  The dropdown menu of the nav bar wasn't working.  No worky.
// Wouldn't drop down.  So, below, I moved "require bootstrap" ABOVE require jquery (which is
// exactly the opposite of what the railstutorial said to do), and now the menu works!
// From: https://stackoverflow.com/questions/10218587/twitter-bootstrap-drop-down-suddenly-not-working
//
// Here's the bugger.  This fixes the dropdown menu.  But now all my integration
// tests that involve select2 fail.  And if I move bootstrap AFTER jquery, then
// my integration tests pass but the dropdown fails.  So either way I've got issues.
//
//= require bootstrap
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree .
//= require select2.full
//
/////////////////////////////////////////////////////////////////////////////
// TOC
//
// main.js
//   Global variables common to all pages, and the turbolinks page load event 
//   dispatcher.
//
// common.js
//   Helper and utility code common to other modules.
//
// properties.js
//   All code related to the pages that show properties.
//
// static_pages.js
//   Code for static pages, such as the root home page and all its events.
//
/////////////////////////////////////////////////////////////////////////////
// CONVENTIONS
//
// * Event functions: Named to signify that they are the actual bound event
//     functions. 
//
//     eventPageDescription - example: resizeWindowEventPropertyShow()
//
// * Event helpers: Not actually bound to events, but the bound code calls
//     the helper.
//
//     eventPageDescriptionHelper - example: onLoadEventPropertyShowHelper()
//
/////////////////////////////////////////////////////////////////////////////
