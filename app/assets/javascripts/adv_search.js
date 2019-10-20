/////////////////////////////////////////////////////////////////////////////
// adv_search.js
//
// Code relating to advanced search page.
//
//
// TOC: 
//
// onLoadEventAdvSearchHelper():
//
//   Code for (turbolinks) on-load event for advanced search page. 
//   Called from main.js#turbolinks:load().
//
/////////////////////////////////////////////////////////////////////////////
'use strict';
/**
 * @module adv_search
 */
 
/////////////////////////////////////////////////////////////////////////////
// Globals
/////////////////////////////////////////////////////////////////////////////
/* global $ */
/* global DEBUG */
/* global location */

// The difference between where the "No Properties Found" element, or the
// "Search Results" element is currently sitting on the screen vertically,
// and the position where it will rest directly under the screen header.
// So, when we come to this page with search results, it knows it has
// to scroll this distance to put the "Search Results" element right
// where it needs to be at the top.
var giDiff;

/////////////////////////////////////////////////////////////////////////////
// Code
/////////////////////////////////////////////////////////////////////////////

//
//
// advanced search page (properties#adv_search)
//
//

/////////////////////////////////////////////////////////////////////////////
// #onLoadEventAdvSearchHelper
/**
 * @summary Code for (turbolinks) on-load event for advanced search page 
 * (properties#adv_search).  
 * 
 * @desc TODO.
 * 
 * Called from main.js#{@link turbolinks:load}.
 * 
 * @author Derek Carlson
 * @since 12/5/2018
 * 
 */
function onLoadEventAdvSearchHelper() {
  if (DEBUG) console.log("Initializing advanced search page javascript...");

  $('#ps-dl-pdf-adv-search').click(as_post_to_pdf_on_click);

  $('#as-architects-select2').select2({
    placeholder: "Select Architects",
    tags: true, // This & selectOnBlur & createSearchChoice
                // are needed to allow entry of custom addresses
                // that aren't in our database. See:
                // http://stackoverflow.com/questions/25616520/
                //   select2-dropdown-allow-new-values-by-user-when-user-types
    selectOnBlur: true, 
    selectOnClose: true,
    createSearchChoice: function (term, data) {
        if ($(data).filter(function () {
            return this.text.localeCompare(term) === 0;
        }).length === 0) {
            return {
                id: term,
                text: term
            };
        }
    },
    allowClear: true,
  });

  $('#as-builders-select2').select2({
    placeholder: "Select Builders",
    tags: true, // This & selectOnBlur & createSearchChoice
                // are needed to allow entry of custom addresses
                // that aren't in our database. See:
                // http://stackoverflow.com/questions/25616520/
                //   select2-dropdown-allow-new-values-by-user-when-user-types
    selectOnBlur: true, 
    selectOnClose: true,
    createSearchChoice: function (term, data) {
        if ($(data).filter(function () {
            return this.text.localeCompare(term) === 0;
        }).length === 0) {
            return {
                id: term,
                text: term
            };
        }
    },
    allowClear: true,
  });

  $('#as-styles-select2').select2({
    placeholder: "Select Style",
    selectOnClose: true,
    allowClear: true,
  });

  $('#as-types-select2').select2({
    placeholder: "Select Type",
    selectOnClose: true,
    allowClear: true,
  });

  // If "Is Between", show the "to date"
  onChangeYearBuilt();

  // 
  // Event: resize
  //
  // Note: On a phone, most vertical scrolls will either hide or
  // show the URL bar on Chrome, and this triggers a resize
  // event because the Y size of the screen changed.
  //
  // Below, when the width of the browser is changed, we need to
  // update the position of the Search Results text.  This is
  // because the height of the header starts to shrink when the
  // width gets below 570 pixels, and also because the length
  // of the entire document changes when the window shrinks
  // and that starts to cause elements to wrap, which causes
  // the document to lengthen and the positions of items
  // to change vertically.
  window.addEventListener("resize", function(event) {
    calcDeltaYForSearchResultsToHeader();
  });

  // Initialize giDiff
  calcDeltaYForSearchResultsToHeader();
  
  // Once they click Search, flag_search_hit becomes true, and we
  // scroll the page down to the search results.  flag_search_hit 
  // is false when we come to this page from the Advanced Search
  // link on the homepage, and in that case, we don't want to 
  // scroll down to anything.
  console.log ("Near end of page init routine.");
  if (document.getElementById("flag_search_hit").value == "True") {
    console.log ("Scrolling to top at start of page refresh.");
    scrollSearchResultsToTop();
  } 
}

/////////////////////////////////////////////////////////////////////////////
// #scrollSearchResultsToTop
/**
 * @summary Keeps the top of the "Search Results" div just below the bottom
 *          of the menu bar div.
 * 
 * @author Derek Carlson
 * @since 10/14/2019
 * 
 */
function scrollSearchResultsToTop() {
    console.log("Calling window.scrollTo");
    window.scrollTo({
      top: window.scrollY + giDiff,
      left: 0,
      behavior: 'smooth'
    });
}

/////////////////////////////////////////////////////////////////////////////
// # calcDeltaYForSearchResultsToHeader
/**
 * @summary Calculates the vertical pixel distance between the top of the 
 *   "Search Results" element and the bottom of the top header bar.
 *          
 * @author Derek Carlson
 * @since 10/20/2019
 * 
 */
function calcDeltaYForSearchResultsToHeader() {
    var e = document.getElementById("adv_search_results")
    var r = e.getBoundingClientRect();

    var e2 = document.getElementById("black-bar")
    var r2 = e2.getBoundingClientRect();

    giDiff = r.top - r2.bottom

    // Window is sitting at scrollY.  So now we modify that by adding
    // (or subtracting) the difference betweeen the bottom of the black
    // menu bar and the top of the Search Results div, so that the
    // Search Result is always just a little below the black/white bar.
}

/////////////////////////////////////////////////////////////////////////////
// #onChangeYearBuilt
/**
 * @summary Toggles visibility of "to date" for Year Built, having "to date"
 *          only be visible when looking at a range between two dates.
 * 
 * @author Derek Carlson
 * @since 1/3/2019
 * 
 */
function onChangeYearBuilt() {
	if (document.getElementById("as_yearbuilt_comparison").value === "Is Between") {
		document.getElementById("as_yearbuilt_to_year_container").style.visibility = "visible";
	} else {
		document.getElementById("as_yearbuilt_to_year_container").style.visibility  = "hidden";
	}
}

/////////////////////////////////////////////////////////////////////////////
// #resetAllFilters
/**
 * @summary Clears all search criteria.
 * 
 * @author Derek Carlson
 * @since 1/3/2019
 * 
 */
function resetAllFilters() {
    if (confirm("Clear all search fields?")) {
        document.getElementById("_filter").value = "";
        document.getElementById("_apn").value = "";
        document.getElementById("_ahadid").value = "";

        document.getElementById("as_fuzzy_architects").value = "";
        document.getElementById("as_fuzzy_builders").value = "";

        $('#as-architects-select2').val([]).trigger('change')
        $('#as-builders-select2').val([]).trigger('change')
        document.getElementById("as_yearbuilt_from_year").value = "";
        document.getElementById("as_yearbuilt_to_year").value = "";
        $('#as-styles-select2').val([]).trigger('change')
        $('#as-types-select2').val([]).trigger('change')
    }
	// For some reason this clears the whole page via an automatic reload.
	// No clue why the above causes a reload, but it does what I need it
	// to do anyway.  How often do things work out that way for ya?
}

/////////////////////////////////////////////////////////////////////////////
// #as_fuzzy_architects_on_click
/**
 * @summary Clears initial placeholder text.
 * 
 * @author Derek Carlson
 * @since 2/5/2019
 * 
 */
function as_fuzzy_architects_on_click() {
    var b;
    b = document.getElementById("as_fuzzy_architects");

    if (b.value == "Separate names with semicolons, e.g. Bennett;Haskell;Cyril.") {
        b.value = "";
    }
}

/////////////////////////////////////////////////////////////////////////////
// #as_fuzzy_builders_on_click
/**
 * @summary Clears initial placeholder text.
 * 
 * @author Derek Carlson
 * @since 2/5/2019
 * 
 */
function as_fuzzy_builders_on_click() {
    var b;
    b = document.getElementById("as_fuzzy_builders");

    if (b.value == "Separate names with semicolons, e.g. Bennett;Haskell;Cyril.") {
        b.value = "";
    }
}

/////////////////////////////////////////////////////////////////////////////
// #as_post_to_pdf
/**
 * @summary Builds up POST params with all the search criteria and then
 *   POSTS to adv_search.pdf which uses those params to build up query
 *   string, use that to pull out all the properties and display them
 *   in the PDF file.
 * 
 * @author Derek Carlson
 * @since 10/8/2019
 * 
 */
function as_post_to_pdf_on_click() {
  var form = document.createElement("form");
  var e;

  form.method = "POST";
  form.action = "adv_search.pdf";   
  //form.target = "print_popup"
  //form.onsubmit="window.open('about:blank','print_popup','width=1000,height=800');">
  
  form.appendChild(document.getElementById("_filter"));  
  form.appendChild(document.getElementById("_apn"));  
  form.appendChild(document.getElementById("_ahadid"));  
  form.appendChild(document.getElementById("as-architects-select2"));  
  form.appendChild(document.getElementById("as_fuzzy_architects_comparison"));  
  form.appendChild(document.getElementById("as_fuzzy_architects"));  
  form.appendChild(document.getElementById("as-builders-select2"));  
  form.appendChild(document.getElementById("as_fuzzy_builders_comparison"));  
  form.appendChild(document.getElementById("as_fuzzy_builders"));  
  
  form.appendChild(document.getElementById("as_yearbuilt_comparison"));  
  form.appendChild(document.getElementById("as_yearbuilt_from_year"));  
  form.appendChild(document.getElementById("as_yearbuilt_to_year"));  
  form.appendChild(document.getElementById("as-styles-select2"));  
  form.appendChild(document.getElementById("as-types-select2"));  

  document.body.appendChild(form);

  form.submit();
}

function get_scroll_height() {
  return Math.max(
        document.body.scrollHeight, document.documentElement.scrollHeight,
        document.body.offsetHeight, document.documentElement.offsetHeight,
        document.body.clientHeight, document.documentElement.clientHeight
        );
}