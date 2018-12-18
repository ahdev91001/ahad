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

}
