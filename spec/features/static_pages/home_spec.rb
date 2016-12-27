require 'rails_helper'

RSpec.feature "Actions available from home page", :type => :feature do
  scenario "TEMP: Search for a property via the testform" do

    visit "/static_pages/testform"
    fill_in "id", :with => "653 Alameda St"
    
    fill_in "datalistdude", :with => "Altadena"
    
    find('#selectdude').find(:xpath, 'option[1]').select_option
    find('#selectdude').find("option[value='123']").click    
    click_button("Submit")
    
    expect(page).to have_text("653 Alameda St")
  
  end
  
#  scenario "Search for a property that exists in the database" do
    # pending("In process - DDC")
#    visit "/"
    # Below doesn't work... how to fill in text in select2,
    # because the dropdown being loaded by ajax won't occur...
    # in fact, javascript isn't run at all... so I suppose
    # it will act like a plain old empty select...?
    #fill_in "sp-home-addr-select2", :with => "Test"
#  end
  
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

