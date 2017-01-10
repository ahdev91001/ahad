require 'rails_helper'
require 'pry-byebug'

# TODO: Q. Do we want to search when people hit ENTER from the text field?
#
# 1. Click a property from the dropdown list and click search.
# 2. Type in a valid property in the text field and click search.
#     => Both 1 & 2 lead to property found page. 
#
# 3. Type in a property we do NOT have in the text field and click search.
#     => Show property not found page.  
#
# 4. TODO: Just click search with nothing selected or touched.
#     => For now should do nothing, but perhaps check for some css being
#        visible saying "fill this in"
#
# 5. TODO: Type a space or two and click search.
#     => Ditto #4
#
RSpec.feature "Actions available from home page", 
  :type => :feature, js: true do
  
  # 1 & 2 ####################################################################
  context "search for a property that exists in the database" do

    before(:each) do
      FactoryGirl.create(:property, id: "10064", address1: "653 Alameda St")
      FactoryGirl.create(:property, id: "10002", address1: "259 Acacia St")
      FactoryGirl.create(:property, id: "16494", address1: "1090 Rubio St")
    end
    
    # 1 ######################################################################
    scenario "by using dropdown list" do
      
      visit "/"
      find("#select2-sp-home-addr-select2-container").click
      wait_for_ajax
      find(".select2-results li:nth-child(3)").click # maybe by name, not index
      click_button("sp-home-search-btn")
      expect(page).to have_css("#ps-addr-title-zoom-container", wait: 5)
      expect(page).to have_css("#ps-addr-title-zoom__text", 
        :text => "1090 Rubio St")
 
    end  

    # 2 ######################################################################
    scenario "by typing directly into combobox" do
      
      visit "/"
      find("#select2-sp-home-addr-select2-container").click
      wait_for_ajax
      # Turn below into a PageHelper function
      # select_property_in_db
      find(".select2-search__field", wait: 5).set("259 Acacia St\n")
      
      find("#select2-sp-home-addr-select2-container", 
        text: "259 Acacia St")
      
      # 1. without second find 
      # 2. with second find without \n
      # 3. with second find with \n
      #
      # A1. WORKS: With \n and without second find:
      #  Q: Why does this one seem to block before search button click
      #     but in case 3 below, that set doesn't block and search
      #     gets clicked too soon?
      #
      # A2. WORKS: With \n, with second find WITHOUT \n. 
      #
      # A3. FAILS: With \n, with second find WITH \n: Find with \n seems to
      #     literally be looking for that ending character in the text,
      #     and it appears to be stripped above in the set and instead
      #     treated as a literal hitting of the enter key.
      #
      # B1. FAILS: Without \n and without second find:
      #     It hilights the correct option in the dropdown list, but
      #     that never gets actually "selected" (as in someone clicking
      #     the mouse or hitting the enter key), so when the search
      #     button gets clicked, the dropdown just rolls up and the
      #     combobox is still blank and only containing the placeholder
      #     text.  Thus, the search goes through (CHANGE THIS WHEN
      #     ADD JAVASCRIPT) and the "blank" property is not found.
      #
      # B2. FAILS: Without \n and with second find WITHOUT \n:
      #     It highlights the selection in the dropdown, but does NOT
      #     then put it into the #select2-sp-home-addr-select2-container 
      #     element, so the second find times out.  
      #
      # B3. FAILS: Without \n and with second find with \n:
      #     Just hangs on second find, because without the first \n,
      #     the selection is never "acknowledged" and inserted into
      #     the #select2-sp-home-addr-select2-container element.
      #     But even if it did, it would not match the additional
      #     \n, as was the case with A3.
      
      click_button("sp-home-search-btn")
      expect(page).to have_css("#ps-addr-title-zoom-container", wait: 5)
      expect(page).to have_css("#ps-addr-title-zoom__text", 
        :text => "259 Acacia St")
 
    end  
    
  end

  # 3 ########################################################################
  scenario "search for a property that doesn't exist in the database" do

      FactoryGirl.create(:property, id: "10064", address1: "653 Alameda St")
      FactoryGirl.create(:property, id: "10002", address1: "259 Acacia St")
      FactoryGirl.create(:property, id: "16494", address1: "1090 Rubio St")
      
      visit "/"
      find("#select2-sp-home-addr-select2-container").click
      wait_for_ajax
      # TODO: Turn below, the 2 statements, into a PageHelper function
      # select_property_not_in_db()
      find(".select2-search__field", wait: 5).set("1000 E Mount Curve Ave")
      find("#select2-sp-home-addr-select2-container", 
        text: "1000 E Mount Curve Ave")
      
      # B2. WORKS: Without \n, with second find WITHOUT \n. 
      #     Apparently this set(), in conjunction with select2 (since
      #     select2 doesn't hijack things by hilighting the option
      #     in the dropdown list [hypothesis]) is enough for select2
      #     to automatically transfer the value into 
      #     #select2-sp-home-addr-select2-container without the need
      #     for the \n signifying hitting the enter key. But if
      #     the second find isn't there to give it a second to 
      #     "take" or transfer, then #select2-sp-home-addr-select2-container
      #     just stays blank because the search button is clicked 
      #     before it can be updated from the .select2-search__field.
      click_button("sp-home-search-btn")
      expect(page).to have_css(".search-not-found-results", wait: 5)
      expect(page).to have_text("for: 1000 E Mount Curve Ave")
  end

  # 4 ########################################################################
  #
  # TODO: This test currently runs and passes and should fail.
  # Need to add code to js button click to make sure matches
  # \w or something.  Then, need to find the right way to check
  # and make sure it stayed on the home page... find capybara
  # way to check for page title, perhaps.
  # Maybe assert a css saying "please fill in address" starts
  # hidden, then check for it being shown.  Think this through.
  #    
  scenario "Search clicked with an empty select2 stays on homepage" do
    pending('rethink ux and fix search button js code when address' +
      'blank or just whitespace')
    visit "/"  
    click_button("sp-home-search-btn")
    sleep 3 # TODO: Come up with better solution
    expect(page).to have_text("Architectural Database") # seach
    # for an ID or something, not just test
    
  end

  # 5 ########################################################################
  scenario "Search clicked with some whitespace in select2 " +
           "stays on homepage"
  
  
  # STOP HERE... clean up below, move all comments to dev log text file
  # and delete function.
  #
  # Then, fix DISABLEDonclick="rootHomeSearchClicked()" so it is set
  # to active via JS, and remove this type of intermixed nonsense from html
  
  scenario "Search for a property that exists in the database" do
    # setup
    FactoryGirl.create(:property, id: "10064", address1: "653 Alameda St")
    FactoryGirl.create(:property, id: "10002", address1: "259 Acacia St")
    FactoryGirl.create(:property, id: "16494", address1: "1090 Rubio St")
    
    # exercise 
    visit "/"  # why does it default to 653 Alameda, and can we now set it to
               # blank to test AJAX?
    
    
    # Below... this drops down the select2 and initiates the
    # AJAX call.
    find("#select2-sp-home-addr-select2-container").click
    # Then wait for AJAX to load all the dropdown options:
    wait_for_ajax

    #find(".select2-search__field").click
    # binding.pry

    # sleep 3  # STOP HERE... just a test to see if race condition issue
    # since I can see that css when I look at page.body in the pry
    # IT WAS A RACE CONDITION... guess wait for ajax doesn't wait
    # for DOM to be updated with new css...
    #
    # Maybe add a wait: 10
    
    # find(".select2-search__field", wait: 5).set("1090 Rubio St")  # WORKS
    
    #    find(".select2-search").set("1000 E Mount Curve Ave.") # no error, but no work
    #    find(".select2-input").set("1000 E Mount Curve Ave.") # no such field

    # http://stackoverflow.com/questions/12771436/
    #   how-to-test-a-select2-element-with-capybara-dsl
    find(".select2-results li:nth-child(3)").click 
    # This by itself works, to select an item directly from the dropdown
    # list without typing anything.  params[:id] is 16494
    
    #binding.pry
    
    click_button("sp-home-search-btn") # , wait: 3)
    
    # As per: https://makandracards.com/makandra/
    #   12139-waiting-for-page-loads-and-ajax-requests-to-finish-with-capybara
    # "There is no known reliable way to detect if the browser has finished 
    #  loading the page."
    # Thus, we will use their suggestion below, which waits until a specific
    # element or class or text appears, or until the capybara default timeout.
    
    #wait_until do
    #  page.has_css?('#ps-addr-title-zoom-container')
    #end
    
    #sleep 3 # STOP HERE... how to have it wait for the page to load?  DONE
            # And, I'd also like to know how to inspect the page DONE
            # with pry... maybe try debugger or byebug below DONE
            # and see if I can inspect...
            # ALSO: What is view source different from what is truly
            # in the select2 DOM... and where is .select2-results in Tilt?
            # Clear out default options from home.html.erb too.
            # Add click on X for search.  And spaces.
            # And figure out how to select input box and type or fill in
            #  1000 E Mount Curve Ave, not in the list
            # Then remove stuff from home.html.erb
            # Then take all these notes out of this function, clean
            # it up, and move them, along with lessons learned, to my
            # dev log document.
    # verify
    # 1 = 259 Acacia
    # 3 = 1090 Rubio St
    # expect(page).to have_text("1090 Rubio St") #fails, 'cause AJAX on search
    # page dropdown contains all the addresses loaded... so home page and
    # results page have the same content.  So, need to check for something
    # unique to the property show page.  It will block and wait 
    # until the element appears, or the timeout is reached.
    
    # sleep 2 # perhaps due to animation, fails without sleep
    
    expect(page).to have_css("#ps-addr-title-zoom-container", wait: 5)
    expect(page).to have_css("#ps-addr-title-zoom__text", :text => "1090 Rubio St")
    
    # puts page.body in debugger
    # save_and_open_page # opens page in a browser
    #binding.pry #puts page.body works in pry...
    # this is where you can see the modified select2 source with ul and li
    # and AJAX results, which may not show up on the View Source
    
    # teardown (database_cleaner wipes the db)
  end

  
end # feature

