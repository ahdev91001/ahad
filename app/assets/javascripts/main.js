/////////////////////////////////////////////////////////////////////////////
// main.js
//
// Handles all non-page specific code, and non-cross-module utility code.
// e.g. this is the entry point for the turbolinks:load event that is
// called when each new page is loaded.
//
// Also contains global definitions that are used across multiple modules.
//
//
// TOC:
// 
// document.ready(): Event, not used at the moment (12/3/16 DDC).
//
// window.load(): Event, for loading Google Map load script.
//
// turbolinks.load()
//
//   Event, fired on fresh page loads as well as intra-site links, delegates
//   to code specific to each different page load.
//
/////////////////////////////////////////////////////////////////////////////
'use strict';
/**
 * @module main
 */
 
/////////////////////////////////////////////////////////////////////////////
// Globals
/////////////////////////////////////////////////////////////////////////////
/* global $ */

// From adv_search.js
/* global onLoadEventAdvSearchHelper */

// From properties.js
/* global onLoadEventPropertyShowHelper */
/* global onLoadEventPropertyNotFoundHelper */

// From static_pages.js
/* global onLoadEventRootHomeHelper */
/* global onLoadEventTestformHelper */

/* global location */

/* global jQuery */

/**
 * Global debug variable for logging across all modules.
 * @constant
 * @global
 */
var DEBUG = true;  // "const" doesn't work in IE 8, 9, 10


/////////////////////////////////////////////////////////////////////////////
// Code
/////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////
// #document.ready
/** 
 * @function document.ready
 * 
 * @desc 'ready' is fired first time site is first loaded, 
 * even with turbolinks.
 * 
 * @author Derek Carlson
 * @since 12/7/2016
 * 
 */
$(document).on('ready', function (e) {
  if (DEBUG) console.log("Event: ready() at: " + e.timeStamp);


});

$(document).on('turbolinks:before-cache', function() {  
  // Below prevents funky mangled display of select2 upon clicking
  // the back button on the browser
  $('#as-architects-select2').select2('destroy');
  $('#as-builders-select2').select2('destroy');
  $('#as-styles-select2').select2('destroy');
  $('#as-types-select2').select2('destroy');
} );

/////////////////////////////////////////////////////////////////////////////
// #window.load
/**
 * @function window.load
 * 
 * @desc Used to load Google Map init script.
 * 
 * @todo Uncomment the call, or remove this function entirely. DDC 12/8/16
 * 
 * @author Derek Carlson
 * @since 12/7/2016
 * 
 */
$(window).on('load', function (e) {


});


/////////////////////////////////////////////////////////////////////////////
// #turbolinks:load
/** 
 * @function turbolinks:load
 * 
 * @desc Delegate page load code to various functions depending on which
 * page (or type of page) is being loaded.
 * 
 * @author Derek Carlson
 * @since 12/7/2016
 * 
 */
/*
 * Suspect below needs to be turbolinks:load, for when we are at
 * a non-home page, and we click back to the homepage and need the
 * bg image re-initialized.
 *
 * With Turbolinks, the page header is always the same and the
 * body is the only thing that gets swapped out when in-site
 * links are clicked.
 *
 * Thus, we only want certain code to run on certain pages,
 * but each page load is going to come through this event,
 * so we need to delegate to page-specific code here.
 *
 * I'm sure there's a cleaner, more proper way to deal with 
 * this, but haven't found it yet. Or, could just disable
 * Turbolinks.  But will give it a shot until the code
 * to deal with it gets too unruly.
 */
$(document).on('turbolinks:load', function (e) {

  if (DEBUG) {
    console.log("Got to turbolinks:load at " + e.timeStamp);
    console.log("URL: " + window.location.href);
  }
  
  var page = "";

  if (window.location.href.match(/.+\/$/)) {
    page = "root";
  } else {
    page = window.location.href.match(/.+\/(.+)/)[1];
  }
  
  if (DEBUG) console.log("Turbolinks page: " + page);
  
  // On small screens, hide the menu on load in case of user
  // hitting back button.  Otherwise the slid-in menu is just
  // sitting there from before.
	if(window.innerWidth < 768) {
  	$("#burger").show();
  	$("#nav").hide();
	}
	
  // Turn off property address fade in/out based on scrolling
  // for when we're on non-property view pages. Not sure
  // if the event persists across turbolinks page loads,
  // but playing it safe here.
  $(window).off('scroll');
  
  // Delegate to code that runs specific to each page loaded
  if (page == "root") {
    // Home page with search box -- root 'static_pages#home'
    onLoadEventRootHomeHelper();
    // Select2, when rails linked to it, would get squished.
    // However, when I resized the window, I would notice that
    // all the resize events got called (like scale the BG image)
    // and select2 would "pop back" to normal.  So I decided
    // to try to force a resize event here on page load so that
    // it would kick select2 into shape if it were squished.
    // Sure enough, that did the trick.
    $(window).trigger('resize');
  } else if (page.match(/adv_search/)) {
    onLoadEventAdvSearchHelper();
    $(window).trigger('resize');
  } else if (page == "testform") {
  	onLoadEventTestformHelper();
  } else if (window.location.href.match(/properties\/\d+/)) {
    // property#show page -- e.g. /properties/12413
    onLoadEventPropertyShowHelper(); // properties.js
  } else if (window.location.href.match(/search.*/)) {
    // property#[not found] -- e.g. /search?id=1000+E+Mount+...
    onLoadEventPropertyNotFoundHelper(); // properties.js
  } 
  

});

/////////////////////////////////////////////////////////////////////////////
// #findGetParameter
/** 
 * @function findGetParameter
 * 
 * @parameterName 
 * 
 * @desc Returns the parameter value from a GET string in the URL.
 *       e.g. for the URL /properties/10001?ret=search, to get the
 *       parameter value for "ret" which is "search", use
 *       findGetParameter("ret");
 * 
 * @author Derek Carlson
 * @since 8/30/2019
 * 
 */
/* Copied from: https://stackoverflow.com/questions/5448545/
 *                      how-to-retrieve-get-parameters-from-javascript
 */
function findGetParameter(parameterName) {
    var result = null,
        tmp = [];
    location.search
        .substr(1)
        .split("&")
        .forEach(function (item) {
          tmp = item.split("=");
          if (tmp[0] === parameterName) result = decodeURIComponent(tmp[1]);
        });
    return result;
}

/**
 *
 * Created by Borbás Geri on 12/17/13
 * Copyright (c) 2013 eppz! development, LLC.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 */

