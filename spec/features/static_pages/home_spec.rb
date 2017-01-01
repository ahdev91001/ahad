require 'rails_helper'

RSpec.feature "Actions available from home page", :type => :feature, js: true do
  scenario "TEMP: Search for a property via the testform" do

    visit "/static_pages/testform"
    fill_in "id", :with => "653 Alameda St"
    
    fill_in "datalistdude", :with => "Altadena"
    
    find('#selectdude').find(:xpath, 'option[1]').select_option
    find('#selectdude').find("option[value='123']").click    

    expect(page).to have_css('div#testform-div-to-change')
    expect(page).to have_selector('div#testform-div-to-change', 
      text: "I have seen the light" )
    expect(page).to have_selector('div#testform-div-to-change', 
      text: /i have seen the light/i )
    
    sleep(2)
    click_button("Submit")
    
    expect(page).to have_text("653 Alameda St")
    sleep(2)
    
  end
  
  if false
    scenario "Search for a property that exists in the database" do

      visit "/"

      find('#sp-home-addr-select2').find("option[value='10064']").click    
      click_button("sp-home-search-btn")

      expect(page).to have_text("653 Alameda St")
    end

    scenario "Search for a property that DOESN'T exist in the database" do

      visit "/"

      find('#sp-home-addr-select2').find("option[value='1000 E Mount Curve Ave']").click    
      click_button("sp-home-search-btn")

      expect(page).to have_text("for: 1000 E Mount Curve Ave")
    end
  end # if false
  
#  scenario "Search for a property not found in the database" do
    
#    pending("Not yet started - DDC")
    
    # Here, just do property found, property not found (for whatever reason)
    #
    # So then, where do we test all these different versions of the
    #   reason why the property would not be found, and what to do
    #   in those situations?
    
    # Situations leading up to this:
    #
    # => property is legitimately not in the database
    # => address contains a typo
    # => address is legit, but in a different form than in the DB,
    #    (e.g. 1000 E Mount Curve Ave vs. 1000 Mount Curve Ave East)
    # => property is in the DB, but that record is corrupt
    # => property was in the DB, but that record was accidentally deleted
    
    # visit "/"

    # <select id="sp-home-addr-select2"></select>
    # fill_in "Full name", :with => "My Name"

    # <button class="btn-arrow-anim" 
		#	    type="button" onclick="rootHomeSearchClicked()">
		#		  <span class="btn-arrow-anim__text">Search </span>
		#		</button>
    # click_button "Search"

    # expect(page).to have_text("Address not found")
#  end
end

