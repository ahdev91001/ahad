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
  OnChangeYearBuilt();
}

/////////////////////////////////////////////////////////////////////////////
// #OnChangeYearBuilt
/**
 * @summary Toggles visibility of "to date" for Year Built, having "to date"
 *          only be visible when looking at a range between two dates.
 * 
 * @author Derek Carlson
 * @since 1/3/2019
 * 
 */
function OnChangeYearBuilt() {
	if (document.getElementById("as_yearbuilt_comparison").value === "Is Between") {
		document.getElementById("as_yearbuilt_to_year_container").style.visibility = "visible";
	} else {
		document.getElementById("as_yearbuilt_to_year_container").style.visibility  = "hidden";
	}
}