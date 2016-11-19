/* global $ */
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
		
		$('#inputid').select2({placeholder: 'Enter an Altadena address here...', allowClear: true});

  } // page == root
});

function static_pages_root_search_clicked() {
	window.location.href = "properties/" + 
		$("#inputid").val();
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

