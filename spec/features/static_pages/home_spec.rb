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

  include PropertySpecPageHelper  
  include StaticPagesSpecPageHelper
  let(:home_page) { StaticPagesSpecPageHelper::HomePageSpecPageHelper.new }

  # 1 & 2 ####################################################################
  context "search for a property that exists in the database" do

    before(:each) do
      FactoryGirl.create(:property, id: "10064", address1: "653 Alameda St")
      FactoryGirl.create(:property, id: "10002", address1: "259 Acacia St")
      FactoryGirl.create(:property, id: "16494", address1: "1090 Rubio St")
    end
    
    # 1 ######################################################################
    scenario "by using dropdown list" do
      
      home_page.visit_page.click_select2_item("1090 Rubio St").click_search
      expect(page).to show_property_at("1090 Rubio St")

    end  

    # 2 ######################################################################
    scenario "by typing directly into combobox" do
      
      home_page.visit_page.
        type_text_for_existing_item_into_select2("259 Acacia St").click_search
      expect(page).to show_property_at("259 Acacia St")

    end  
  end

  # 3 ########################################################################
  scenario "search for a property that doesn't exist in the database", :wip => true do

      # Creating a few properties, so that the select2 AJAX call proceeds
      # and loads the dropdown list, because that can affect thing even
      # when someone types an address into the search field that isn't one
      # of the addresses in the dropdown list.  Basically I want to set up
      # select2 state to mirror what it will be like in real production.
      FactoryGirl.create(:property, id: "10064", address1: "653 Alameda St")
      FactoryGirl.create(:property, id: "10002", address1: "259 Acacia St")
      FactoryGirl.create(:property, id: "16494", address1: "1090 Rubio St")
      
      home_page.visit_page.type_text_for_unlisted_item_into_select2(
        "1000 E Mount Curve Ave").click_search
      expect(page).to show_property_not_found("1000 E Mount Curve Ave")

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
  scenario "search clicked with an empty select2 stays on homepage" do
    pending('rethink ux and fix search button js code when address' +
      'blank or just whitespace')
    visit "/"  
    click_button("sp-home-search-btn")
    sleep 3 # TODO: Come up with better solution
    expect(page).to have_text("Architectural Database") # seach
    # for an ID or something, not just text
    
  end

  # 5 ########################################################################
  scenario "search clicked with some whitespace in select2 " +
           "stays on homepage"
  
  
  # STOP HERE... clean up below, move all comments to dev log text file
  # and delete function.

  scenario "search for a property that exists in the database" do
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

