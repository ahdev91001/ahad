/////////////////////////////////////////////////////////////////////////////
// common.js
//
// JS used across all pages
//
//
// TOC:
//
// generatePDFClicked(): Currently turned off, but used to turn on the
//                       "Please wait, Generating PDF" spinner.
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
    
  if (false) {
    $("#ps-pdf-please-wait-container").css("display", "block")
    $("#ps-pdf-please-wait").css("display", "block")
  }
  // the PDF button itself is a link, so it takes care of jumping
  // to the ..properties/16494.pdf link
}

