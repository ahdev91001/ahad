/* global $ */
/* global google*/
/* global map*/

'use strict';

// Global variables for root page to keep background image
// centered.
var DEBUG = true;  // "const" doesn't work in IE 8, 9, 10
var g_fBGImgAspectRatio = 0.0;
var g_iBrowserWinInnerWidth = 0;
var g_iBrowserWinInnerHeight = 0;

// 'ready' is fired first time, even with turbolinks
$(document).on('ready', function (e) {
  console.log("Got to: ready");
  console.log("At: " + e.timeStamp);
});

// Google Map
//$(window).on('load', function (e) {
//	loadGoogleMapScript();
//});


// suspect below needs to be turbolinks:load, for when we are at
// a non-home page, and we click back to the homepage and need the
// bg image initialized
$(document).on('turbolinks:load', function (e) {
  console.log("Got to turbolinks:load");
  console.log("At: " + e.timeStamp);
  
  // With Turbolinks, the page title is always the same as the
  // body is the only thing that gets continually swapped out.
  // Thus, we only want certain code to run on certain pages.
  //
  // I'm sure there's a cleaner, more proper way to deal with 
  // this, but haven't found it yet. Or, could just disable
  // Turbolinks.  But will give it a shot until the code
  // to deal with it gets too unruly.
  
  var page;

  if (DEBUG) console.log("Turbolinks page:load URL: " +
    window.location.href);

  if (window.location.href.match(/.+\/$/)) {
    page = "root";
  } else {
    page = window.location.href.match(/.+\/(.+)/)[1];
  }
  
  if (DEBUG) console.log("Turbolinks page:load: " + page);
  
  // Turn off property address fade in/out based on scrolling
  // for when we're on non-property view pages
  $(window).off('scroll');
  
  //
  // Home page .ready()
  //
  if (page == "root") {
    if (DEBUG) console.log("Initializing home page vars...");

		// Below: within this load() event, it turns out, at least when
		// run from Cloud9 on Chome, or Heroku on Chrome, this code runs
		// before bgimg gets loaded.  ?!?
		// As per: https://github.com/turbolinks/turbolinks-classic/issues/295
		// turns out the load() event does not always wait for all assets
		// to load, contrary to the documentation I've read.  Worked fine
		// on FireFox and Edge, but not Chrome.  So, the solution was to
		// force the code to run after bgimg was loaded via the following line.
   
  	// --- this section was first stab
    //   document.getElementById("bgimg").addEventListener('load', loadBGImgHandler);
		// However, if image is already cached, the load event never gets called
		// on IE 11.321, so need to also set it up here to cover that case
		//   loadBGImgHandler();
		// --- but intermittently doesn't work on Chrome Win 10
		//     so trying the line below instead
	  $(window).load(loadBGImgHandler);
		$(window).resize(resizebg); // set callback for whenever browser size changes
		
		// Select2 Notes:
		//
		// Select2 expects to receive AJAX data in the following format:
		//
    //@tmphash = {
    //  "results": [
    //      {
    //          "id": "CA",
    //          "text": "California"
    //      },
    //      {
    //          "id": "CO",
    //          "text": "Colarado"
    //      }
    // ]
    //};
    //
    // But what we get back from the properties controller looks like...
    //
    // [{"id":10001,"address1":"251 Acacia St"},
    //  {"id":10002,"address1":"259 Acacia St"}, ...
    // ]
    //
    // So "data" is an array of hashes, and we need to turn that into a hash
    // with 1 key "results", and that key needs to point to an array of hashes,
    // except we need to change the "address1" key to the name "text" that
    // Select2 expects.  This transformation is what processResults does.
    //
		$('#inputid').select2({
			  placeholder: 'Enter an Altadena address here...', 
			  allowClear: true,
			  ajax: {
			    url: "properties.json",
					// url: "<%= properties_path %>.json", // erb not working it seems
			    dataType: 'json',
			    delay: 250,
		      processResults: function (data) {
      			return { 
      				results: data.map(function (x) { return { id: x.id, text: x.address1} } ) 
      			}
    			}
			  }
		});
		
	// 
	// /properties/\d+ page loaded
	//
  } else if (window.location.href.match(/properties\/\d+/)) {
	  if (DEBUG) console.log("We're on a property display page...");
	
		// Even with turbolinks, seems that the relevant events for
		// each page need to be initialized on the page load
		$(window).resize(resizeWindowPropertyView); 
		resizeWindowPropertyView(); // position #addressattopfadesin center,
		                            // just below #ahtitle bar
		
		// googleMapInitialize(); // can't call from here, because google object
		// appears to not be available... hmmm....
		$("#houseimgcontainer").css("opacity", 0);
		$("#houseimgcontainer").animate({opacity: [1, "linear"]}, 1500);
		
		$("#housestory").css("opacity", 0);
		$("#housestory").animate({opacity: [1, "linear"]}, 800);

		$("#addrtitlecontainer").addClass("PreAnimate");

		setTimeout( function() {
			$("#addrtitlecontainer").removeClass("PreAnimate");
			$("#addrtitlecontainer").addClass("AnimateIn");			
		}, 100);

		$("#searchagain").css("bottom", -200);
		setTimeout( function() {
			$("#searchagain").animate({bottom: [0, "linear"]}, 800);
		}, 1100);

		$(window).on('scroll', function () {
		    var scrollTop     = $(window).scrollTop(),
		        elementOffset = $('#addrtitle').offset().top,
		        distance      = (elementOffset - scrollTop - 50),
		        opacity       = 0.0;
				
				if (distance < -100) {
		    	opacity = 1.0;
		    } else if (distance > 0) {
		    	opacity = 0.0;
		    } else {
		    	opacity = (-distance / 100);
		    }
		    $('#addressattopfadesin').css("opacity", opacity);
		});
  } // page == \d+
});

function static_pages_root_search_clicked() {
	if ( $("#inputid").val() > 0 ) {
		window.location.href = "properties/" + 
			$("#inputid").val();
	}
}

function properties_search_again_clicked() {
		window.location.href = "/"
}

/////////////////////////////////////////////////////////////////////////////
//
// Page : Property:View
// Event: Resize browser window
//
// Keep the fade-in/fade-out address div at the top of the page in the center
// and just below the header bar (which shrinks when the browser gets narrow
// or on a phone)
/////////////////////////////////////////////////////////////////////////////
function resizeWindowPropertyView() {
	var addressFadeInOutAtTop	= document.getElementById("addressattopfadesin");
	
	$("#addressattopfadesin").css("top",
	  document.getElementById("ahtitle").clientHeight + 12);
	// turn 12 into a constant at top of property view js page

	$("#addressattopfadesin").width($("#addrtitletext").width() + 10);
	// make width of containing div wide enough for text width in
	// inside <span>
}

// Need to do this here instead of the document.load (turbolinks:load)
// routine because on Chrome bgimg is not loaded when turbolinks:load
// is called, thus .width and .height are 0.  Thus, below is fired
// on the bgimg load() event.
function loadBGImgHandler() {
		g_fBGImgAspectRatio = 
			document.getElementById('bgimg').width / 
			document.getElementById('bgimg').height;
		resizebg();	
}

function resizebg() {
	// Use the || stuff for IE8 and earlier
	g_iBrowserWinInnerWidth = window.innerWidth
		|| document.documentElement.clientWidth
		|| document.body.clientWidth;

	g_iBrowserWinInnerHeight = window.innerHeight
		|| document.documentElement.clientHeight
		|| document.body.clientHeight;
		
	var fDOMAspectRatio = g_iBrowserWinInnerWidth / g_iBrowserWinInnerHeight;
	
	var img = document.getElementById('bgimg'); 
	
	/* If DOM aspect ratio is less than the bg image aspect ratio
	 * (that is, the bg image is wide and the browser is tall and skinny)
	 * then make the bg image the height of the browser, and then scale
	 * and center it horizontally
	 */
	 
	// **** KLUDGE WARNING ****
	//
	// 11/27/16, from Dick:  ...(except background photo not displayed 
	// until after I pressed "Search Again"). 
	// Chrome on Samsung S7, Android 6.0.1.
	// I suspect somehow the g_fBGImgAspectRatio is not getting property
	// set... so hardcoding it below to see if that's the situation (12/1/16)
	//
	// 1900 / 945 = 2.01058 for Altadena_littlehouse_1900_wide.jpg
	if ( (g_fBGImgAspectRatio === null) || (g_fBGImgAspectRatio === undefined) || 
	     (g_fBGImgAspectRatio < 0.1) ) g_fBGImgAspectRatio = 2.01058;
	
	if (DEBUG) {
		console.log("DOM Aspect Ratio: " + fDOMAspectRatio);
		console.log("BG IMG Aspect Ratio: " + g_fBGImgAspectRatio);
	}
	
	if (fDOMAspectRatio <= g_fBGImgAspectRatio) {
		if (DEBUG) console.log("Setting BG IMG height to DOM height...");
		img.height = g_iBrowserWinInnerHeight;
		img.width = g_fBGImgAspectRatio * img.height;
		$("#bgimg").css("left", - (img.clientWidth/2.0 - g_iBrowserWinInnerWidth/2.0));
	} else { 
		// Else DOM is wide and not tall - so set the bg image to the 
		// DOM width, and then scale the vertical appropriately
		if (DEBUG) console.log("Setting BG IMG width to DOM width...");
		$("#bgimg").css("left", 0);
		img.width = g_iBrowserWinInnerWidth;
		img.height = img.width / g_fBGImgAspectRatio;
	}

	$('.select2-container--default').width($('#textboxcontainer').width());
}	


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

// Idea... assign name to element, so can release it
// and then reassign it... and use a global var to
// store the address.  Then call this each time the property changes.
function loadGoogleMapScript() {
	var script = document.createElement('script');
	script.type = 'text/javascript';
	script.src = 'https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false&' + 'callback=googleMapInitialize';
	document.body.appendChild(script);
}
