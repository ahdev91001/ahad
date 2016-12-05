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
// propertyShowSearchAgainClicked(): Jump to home/root page.
//
// googleMapInitialize(): -- IP DDC 12/3/16
//
// loadGoogleMapScript(): -- IP DDC 12/3/16
//
//
// TODO:
//
//   Fix all the css names.
//
/////////////////////////////////////////////////////////////////////////////
'use strict';

/////////////////////////////////////////////////////////////////////////////
// Globals
/////////////////////////////////////////////////////////////////////////////
/* global $ */
/* global DEBUG */
/* global google*/
/* global map*/

//
// property#show globals
//

//
// OLPSH: onLoadPropertyShowHelper related
//
var OLPSH__HOUSE_IMG_FADE_IN_MSEC      = 1500;
var OLPSH__HOUSE_DETAILS_FADE_IN_MSEC  = 800;
var OLPSH__ADDRESS_FADE_IN_START_PX    = 50;
// The *fixed* title address will start fading in when the
// *scrolling* title address is this far below the top of the
// screen.

var OLPSH__ADDRESS_FADE_IN_DISTANCE_PX = 200; 
// The *fixed* title address will become 100% opaque when
// the *scrolling* title address is scrolled this far off the top
// of the screen.

var OLPSH__SEARCH_AGAIN_BEFORE_REVEAL_MSEC = 1100; 
var OLPSH__SEARCH_AGAIN_REVEAL_MSEC        = 800; 
// Litte 'Search Again' box at the bottom stays hidden for
// BEFORE_REVEAL msec and then slides up in REVEAL msec.

//
// RWEPS: resizeWindowEventPropertyShow related
//
var RWEPS__ADDRESS_TOP_GAP      = 12;
// How far in px below header banner to position the fade-in
// address div.

var RWEPS__ADDRESS_TEXT_PADDING = 10;
// Padding in px to right & left of address text within the fade-in
// address div.


/////////////////////////////////////////////////////////////////////////////
// Code
/////////////////////////////////////////////////////////////////////////////

//
//
// property#show
//
//

/////////////////////////////////////////////////////////////////////////////
// #onLoadEventPropertyShowHelper()
//
// Code for (turbolinks) on-load event for property#show page (view a single
// property).  Called from main.js#turbolinks:load().
//
// Inputs : None
// Outputs: None
// Returns: Nothing
// Events : Sets window.resize() and window.scroll()
//
// Notes  :
//
// Set up initial animations upon loading, and set up scroll event
// to handle the fading in/out of the address at the top that shows
// up when the title address scrolls off the top.
//
/////////////////////////////////////////////////////////////////////////////
function onLoadEventPropertyShowHelper() {

  if (DEBUG) console.log("We're on a property display page...");

  // Even with turbolinks, seems that the relevant events for
  // each page need to be initialized on the page load
  $(window).resize(resizeWindowEventPropertyShow); 
  // This will keep the fade-in address at the top just under the header
  // and make sure it is wide enough to contain the text therein
  resizeWindowEventPropertyShow();
  
  // FADE in the content - whoosh!
  
  $("#prop-show-photo-main-container").css("opacity", 0);
  $("#prop-show-photo-main-container").animate({opacity: [1, "linear"]}, 
	  OLPSH__HOUSE_IMG_FADE_IN_MSEC);
		
  $("#prop-show-db-details").css("opacity", 0);
  $("#prop-show-db-details").animate({opacity: [1, "linear"]},
	  OLPSH__HOUSE_DETAILS_FADE_IN_MSEC);
  
  // FLY in that title! Bam!
  
  // Set title to a fixed position (large, and transparent) first  
  $("#prop-show-addr-title-zoom-container").
    addClass("psatzc-pre-animate");

  // Then, 100ms later, switch classes to fire the animation.
  // Can't just put one immediately after the other, or doesn't work.
  setTimeout( function() {
    $("#prop-show-addr-title-zoom-container").
      removeClass("psatzc-pre-animate");
    $("#prop-show-addr-title-zoom-container").
      addClass("psatzc-animate-in");			
  }, 100); // 100ms was arbitrary, and seems to work

  // SNEAK in that search button at the bottom!  Zoop!
  
  // Have little "Search Again >>" button sneak up from the bottom
  // after just a small pause.  UX cute factor.  Hide below
  // screen at -200
  $("#prop-show-search-again-container").css("bottom", -200);
  setTimeout( function() {
    $("#prop-show-search-again-container").animate({bottom: [-1, "linear"]}, 
      OLPSH__SEARCH_AGAIN_REVEAL_MSEC);
  }, OLPSH__SEARCH_AGAIN_BEFORE_REVEAL_MSEC);
  

  // Below sets up scroll event so that the fixed address at the
  // top of the screen fades in as soon as the address titlebar
  // scrolls off the top of the screen, and visa-versa.
  $(window).on('scroll', function () {
    var scrollTop     = $(window).scrollTop(),
		    elementOffset = $('#prop-show-addr-title-zoom').offset().top,
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
    $('#prop-show-addr-title-fader').css("opacity", opacity);
  }); // end window scroll event

} // end onLoadEventPropertyShowHelper()


/////////////////////////////////////////////////////////////////////////////
// #resizeWindowEventPropertyShow()
//
// The window resize() code for property#show page.
//
// Inputs : None
// Outputs: None
// Returns: Nothing
// 
// Notes  :
//
// Keep the fade-in/fade-out address div at the top of the page
// just below the header bar (which shrinks when the browser gets narrow
//  or on a phone)
//
// Dynamically make the address container width just big enough for the
// contained text.
//
/////////////////////////////////////////////////////////////////////////////
function resizeWindowEventPropertyShow() {
	var addressFadeInOutAtTop	= document.getElementById("prop-show-addr-title-fader");
	
	$("#prop-show-addr-title-fader").css("top",
	  document.getElementById("app-layout-header-bar").clientHeight + 
	  RWEPS__ADDRESS_TOP_GAP);

	$("#prop-show-addr-title-fader").
	  width($("#prop-show-addr-title-zoom__text").width() + 
	  RWEPS__ADDRESS_TEXT_PADDING);
	// make width of containing div wide enough for text width in
	// inside <span>, otherwise pops onto 2 lines intermittently
	// with no padding.
}


/////////////////////////////////////////////////////////////////////////////
// #googleMapInitialize() -- IP DDC 12/3/16
//
/////////////////////////////////////////////////////////////////////////////
function googleMapInitialize() {
	
	var locations = [
			["348 Acacia St.",    34.183456, -118.158134, 1]
		];

	if (window.map != null) {
		window.map = null; // free up prior memory reference
	}
	
	window.map = new google.maps.Map(document.getElementById('map'), {
		mapTypeId: google.maps.MapTypeId.ROADMAP
	});

	var infowindow = new google.maps.InfoWindow();

	var bounds = new google.maps.LatLngBounds();

	var i, marker;
	
	for (i = 0; i < locations.length; i++) {
		marker = new google.maps.Marker({
			position: new google.maps.LatLng(locations[i][1], locations[i][2]),
			map: map
		});

		infowindow.setContent(locations[i][0]);
		infowindow.open(map, marker);

		bounds.extend(marker.position);

		google.maps.event.addListener(marker, 'click', (function (marker, i) {
			return function () {
				infowindow.setContent(locations[i][0]);
				infowindow.open(map, marker);
			}
		})(marker, i));
	}

	map.fitBounds(bounds);
	
	var listener = google.maps.event.addListener(map, "idle", function () {
		map.setZoom(15);
		google.maps.event.removeListener(listener);
	});
}

/////////////////////////////////////////////////////////////////////////////
// #loadGoogleMapScript() -- IP DDC 12/3/16
//
// Idea... assign name to element, so can release it
// and then reassign it... and use a global var to
// store the address.  Then call this each time the property changes.
/////////////////////////////////////////////////////////////////////////////
function loadGoogleMapScript() {
	var script = document.createElement('script');
	script.type = 'text/javascript';
	script.src = 'https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false&' + 'callback=googleMapInitialize';
	document.body.appendChild(script);
}

//
// property#show functions tied to HTML
//

function propertyShowSearchAgainClicked() {
		window.location.href = "/"
}




//
//
// property#index
//
//

