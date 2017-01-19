module StaticPagesSpecPageHelper

  class HomePageSpecPageHelper
    include Capybara::DSL
    include WaitForAjax
    
    def visit_page
      visit "/"
      self
    end
    
    def click_search
      click_button("sp-home-search-btn")
      self
    end
    
    def click_select2_item(name_or_list_index)
      find("#select2-sp-home-addr-select2-container").click
      wait_for_ajax
      
      if name_or_list_index.class == Fixnum
        find(".select2-results li:nth-child(#{name_or_list_index})").click
      else
        # Found this idea at: http://stackoverflow.com/questions/12771436/
        #   how-to-test-a-select2-element-with-capybara-dsl, the last
        #   answer.
        within ".select2-results" do
          find("li", text: name_or_list_index).click
        end
      end
      self
    end
  
    ###########################################################################
    # #type_text_for_existing_item_into_select2
    
    # Type text into a select2 search feild specifically when that typed text 
    # is *exactly the same* as one of the items in the dropdown list.  This is
    # important, because capybara+select2 work differently depending on whether
    # the typed item is in the list or not.
    #
    # @author Derek Carlson <carlson.derek@gmail.com>
    #
    # @param stuff [String] the text to be typed into the select2 search field
    #
    # It turns out select2 is somewhat complex.  We have capybara type into a
    # text box marked as .select2-search__field.  In order to get the typed
    # text to register, we have to add a \n to the text because that simulates
    # the hitting of the enter key -- otherwise the text never gets copied from
    # the .select2-search__field into the actual value of the select2 element
    # that the page uses when the form submits (which is the
    # #select2-sp-home-addr-select2-container element)
    #
    # Once the \n forces the hitting of the enter key, one of two things 
    # happens.
    #
    #, the text typed into
    # the .select2-search__field gets copied into another element known as
    # #select2-sp-home-addr-select2-container
    #
    # Below is a list of things I tried before I figured out what actually worked.
    #
    # The A cases (A1, A2, A3) are all for the case where we add a \n to the 
    # text that is typed.  The "second find" referred to is commented out in
    # the actual code below, and was something I was experimenting with to
    # prevent the search button from getting clicked too soon, before the 
    # .set actually registered.
    #
    # A1. WORKS: With \n and without second find:
    #  Q: Here's the crazy thing, though.  If the text typed in was NOT
    #     in the dropdown list, then the .set would NOT block, and if
    #     there weren't a second find, search gets clicked before
    #     the text registers in the select2 which causes failure 
    #     due to a race condition.  You'll notice in the next routine
    #     below 'type_text_for_nonexisting_item_into_select2()' that
    #     the "second find" is uncommented and is actually necessary
    #     to make it work -- it blocks until the typed text actually
    #     registers with the #select2-sp-home-addr-select2-container.
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
    def type_text_for_existing_item_into_select2(stuff)
      find("#select2-sp-home-addr-select2-container").click
      wait_for_ajax
      find(".select2-search__field", wait: 5).set(stuff + "\n")
      # Below is the 'second find' referred to above
      #find("#select2-sp-home-addr-select2-container", 
      #  text: stuff)
      self
    end

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
    def type_text_for_unlisted_item_into_select2(stuff)
      find("#select2-sp-home-addr-select2-container").click
      wait_for_ajax
      find(".select2-search__field", wait: 5).set(stuff)
      find("#select2-sp-home-addr-select2-container", 
        text: stuff)
      self
    end
  
  end

end

RSpec.configure do |config|
  config.include StaticPagesSpecPageHelper, :type => :feature
end
