/////////////////////////////////////////////////////////////////////////////
// properties.js
//
// JS for all property related pages (show, index, etc.)
//
//
// TOC:
//
// onLoadEventPropertyShowHelper():
// 
//   Code for (turbolinks) on load event for property#show page (view a single
//   property).
//
// resizeWindowEventPropertyShow():
//
//   The window resize() code for property#show page.
//
// propertySearchAgainClicked(): Jump to home/root page.
//
//
// TODO:
//
//
/////////////////////////////////////////////////////////////////////////////
'use strict';
/**
 * @module properties
 */
 
/////////////////////////////////////////////////////////////////////////////
// Globals
/////////////////////////////////////////////////////////////////////////////
/* global $ */
/* global DEBUG */
/* global google */
/* global map */
/* global findGetParameter */

//
// Globals common to all property pages
//

/**
 * How far in px below header banner to position the topmost element.
 * @constant
 */
var PROP__TOP_MARGIN_CLEARS_HEADER      = 12;

/**
 * Litte 'Search Again' box at the bottom stays hidden for
 * BEFORE_REVEAL msec and then slides up in REVEAL msec.
 * @constant
 */
var PROP__SEARCH_AGAIN_BEFORE_REVEAL_MSEC = 1100; 

/**
 * Little 'Search Again' box at the bottom stays hidden for
 * BEFORE_REVEAL msec and then slides up in REVEAL msec.
 * @constant
 */
var PROP__SEARCH_AGAIN_REVEAL_MSEC        = 800; 


//
// property#show page globals
//

/** @constant */
var OLPSH___means_onLoadPropertyShowHelper = null; // just for jsdoc readability

/** @constant */
var OLPSH__HOUSE_IMG_FADE_IN_MSEC      = 1500;
/** @constant */
var OLPSH__HOUSE_DETAILS_FADE_IN_MSEC  = 800;

/**
 * The *fixed* title address will start fading in when the
 * *scrolling* title address is this far below the top of the
 * screen in px.
 * @constant
 */
var OLPSH__ADDRESS_FADE_IN_START_PX    = 50;

/**
 * The *fixed* title address will become 100% opaque when
 * the *scrolling* title address is scrolled this far off the top
 * of the screen in px.
 * @constant
 */
var OLPSH__ADDRESS_FADE_IN_DISTANCE_PX = 200; 


/** @constant */
var RWEPS___means_resizeWindowEventPropertyShow = null; // for jsdoc readability

/**
 * Padding in px to right & left of address text within the fade-in
 * address div.
 * @constant
 */
var RWEPS__ADDRESS_TEXT_PADDING = 10;


/////////////////////////////////////////////////////////////////////////////
// Code
/////////////////////////////////////////////////////////////////////////////


//
//
// Common methods to all properties pages
//
//


/////////////////////////////////////////////////////////////////////////////
// #propertySearchAgainClicked
/** 
 * @summary Executes when Search Again button clicked.
 *
 * @author Derek Carlson
 * @since 12/7/2016
 * 
 */
function propertySearchAgainClicked() {
  if (findGetParameter("ret") == "search") {
    window.location.href = "/"
  } else {
    window.location.href = "/properties/adv_search"
  }
}


//
//
// property#show page specific code
//
//


/////////////////////////////////////////////////////////////////////////////
// #onLoadEventPropertyShowHelper
/**
 * @summary Code for (turbolinks) on-load event for property#show page.
 * 
 * @desc Set up initial animations upon loading, and set up scroll event
 * to handle the fading in/out of the address at the top that shows
 * up when the title address scrolls off the top.
 * 
 * Sets window.resize() and window.scroll() events.
 * 
 * Called from main.js#{@link turbolinks:load}.
 * 
 * @author Derek Carlson
 * @since 12/7/2016
 * 
 */
function onLoadEventPropertyShowHelper() {

  if (DEBUG) console.log("We're on a property display page...");

  $('#ps-search-again-btn').click(propertySearchAgainClicked)

  $('#ps-dl-pdf-img').click(generatePDFClicked);

  // Even with turbolinks, seems that the relevant events for
  // each page need to be initialized on the page load
  $(window).resize(resizeWindowEventPropertyShow); 
  // This will keep the fade-in address at the top just under the header
  // and make sure it is wide enough to contain the text therein
  resizeWindowEventPropertyShow();
  
  // FADE in the content - whoosh!
  $("#ps-photo-main-container").css("opacity", 0);
  $("#ps-photo-main-container").animate({opacity: [1, "linear"]}, 
	  OLPSH__HOUSE_IMG_FADE_IN_MSEC);
		
  $("#ps-db-details").css("opacity", 0);
  $("#ps-db-details").animate({opacity: [1, "linear"]},
	  OLPSH__HOUSE_DETAILS_FADE_IN_MSEC);
  
  // FLY in that title! Bam!
  
  // Set title to a fixed position (large, and transparent) first  
  $("#ps-addr-title-zoom-container").
    addClass("psatzc-pre-animate");

  // Then, 100ms later, switch classes to fire the animation.
  // Can't just put one immediately after the other, or doesn't work.
  setTimeout( function() {
    $("#ps-addr-title-zoom-container").
      removeClass("psatzc-pre-animate");
    $("#ps-addr-title-zoom-container").
      addClass("psatzc-animate-in");			
  }, 100); // 100ms was arbitrary, and seems to work (DDC)

  // SNEAK in that search button at the bottom!  Zoop!
  
  // Have little "Search Again >>" button sneak up from the bottom
  // after just a small pause.  UX cute factor.  Hide below
  // screen at -200
  $("#prop-search-again-container").css("bottom", -200);
  setTimeout( function() {
    $("#prop-search-again-container").animate({bottom: [-1, "linear"]}, 
      PROP__SEARCH_AGAIN_REVEAL_MSEC);
  }, PROP__SEARCH_AGAIN_BEFORE_REVEAL_MSEC);

  // Below sets up scroll event so that the fixed address at the
  // top of the screen fades in as soon as the address titlebar
  // scrolls off the top of the screen, and visa-versa.
  $(window).on('scroll', function () {
    var scrollTop     = $(window).scrollTop(),
        elementOffset = $('#ps-addr-title-zoom').offset().top,
        distance      = (elementOffset - scrollTop - 
                        OLPSH__ADDRESS_FADE_IN_START_PX),
        opacity       = 0.0;
				
    if (distance < -OLPSH__ADDRESS_FADE_IN_DISTANCE_PX) {
      opacity = 1.0;
    } else if (distance > 0) {
      opacity = 0.0;
    } else {
      opacity = (-distance / OLPSH__ADDRESS_FADE_IN_DISTANCE_PX);
    }
    $('#ps-addr-title-fader').css("opacity", opacity);
  }); // end window scroll event
  
  
	
} // end onLoadEventPropertyShowHelper()


/////////////////////////////////////////////////////////////////////////////
// #resizeWindowEventPropertyShow
/**
 * @summary window.resize event for properties#show page.
 * 
 * @desc Keep the fade-in/fade-out address div at the top of the page
 * just below the header bar (which shrinks vertically when the browser
 * gets narrow or on a phone).
 * 
 * Dynamically make the fade-in/fade-out address container width just
 * big enough for the contained text.
 *
 * @author Derek Carlson
 * @since 12/7/2016
 * 
 */
function resizeWindowEventPropertyShow() {
  $("#ps-addr-title-fader").css("top",
    document.getElementById("app-layout-header-bar").clientHeight + 
    PROP__TOP_MARGIN_CLEARS_HEADER);

  $("#ps-addr-title-fader").
    width($("#ps-addr-title-zoom__text").width() + 
    RWEPS__ADDRESS_TEXT_PADDING);
  // make width of containing div wide enough for text width in
  // inside <span>, otherwise pops onto 2 lines intermittently
  // with no padding.
}

//
//
// property#[property not found]
//
//

/////////////////////////////////////////////////////////////////////////////
// #onLoadEventPropertyNotFoundHelper
/**
 * @summary Code for (turbolinks) on-load event for property not found page.
 * 
 * @desc Set up initial animation of Search Again button upon loading, 
 * and set up window resize event to keep the title hugging the bottom of the
 * header image.
 * 
 * Sets window.resize() event.
 * 
 * Called from main.js#{@link turbolinks:load}.
 * 
 * @author Derek Carlson
 * @since 1/27/2017
 * 
 */
function onLoadEventPropertyNotFoundHelper() {

  if (DEBUG) console.log("We're on the property not found page...");

  $('#prop-search-again-container').click(propertySearchAgainClicked)
  
  // Even with turbolinks, seems that the relevant events for
  // each page need to be initialized on the page load
  $(window).resize(resizeWindowEventPropertyNotFound); 
  // This will keep the "Property Not Found" title at the top just under
  // the header
  resizeWindowEventPropertyNotFound();
  
  // Have little "Search Again >>" button sneak up from the bottom
  // after just a small pause.  UX cute factor.  Hide below
  // screen at -200
  $("#prop-search-again-container").css("bottom", -200);
  setTimeout( function() {
    $("#prop-search-again-container").animate({bottom: [-1, "linear"]}, 
      PROP__SEARCH_AGAIN_REVEAL_MSEC);
  }, PROP__SEARCH_AGAIN_BEFORE_REVEAL_MSEC);

} // end onLoadEventPropertyNotFoundHelper()


/////////////////////////////////////////////////////////////////////////////
// #resizeWindowEventPropertyNotFound
/**
 * @summary window.resize event for property not found page.
 * 
 * @desc Keep the title div at the top of the page
 * just below the header bar (which shrinks vertically when the browser
 * gets narrow or on a phone).
 *
 * @author Derek Carlson
 * @since 1/27/2017
 * 
 */
function resizeWindowEventPropertyNotFound() {
  $("#pnf-title").css("margin-top",
    document.getElementById("app-layout-header-bar").clientHeight + 
    PROP__TOP_MARGIN_CLEARS_HEADER);
}

/////////////////////////////////////////////////////////////////////////////
// #generatePDFClicked
/** 
 * @summary Executes when the PDF download icon is clicked.
 *
 * @author Derek Carlson
 * @since 1/30/2017
 * 
 */
function generatePDFClicked() {
  $("#ps-pdf-please-wait-container").css("display", "block")
  $("#ps-pdf-please-wait").css("display", "block")
  // the PDF button itself is a link, so it takes care of jumping
  // to the ..properties/16494.pdf link
}


//
//
// property#index
//
//