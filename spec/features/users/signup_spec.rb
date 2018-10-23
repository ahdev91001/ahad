require 'rails_helper'
require 'pry-byebug'
#############################################################################
# create_spec.rb
#
# JavaScript/Selenium feature tests for the user signup page.
#
# Tests:
#
# 1. Create an invalid submission and make sure the new uses was NOT added.
#
# Since 10/23/2018 Derek Carlson <carlson.derek@gmail.com>
#############################################################################
RSpec.feature "Actions available user signup page", 
  :type => :feature, js: true do


  # 1 ########################################################################
  context "a form submission with invalid data" do

    # 1 ######################################################################
    scenario "does not create a new user" do

# TODO: Figure out how to do something like this:

#  before_count = User.count
#  post users_path, params: { user: { name:  "",
#                                     email: "user@invalid",
#                                     password:              "foo",
#                                     password_confirmation: "bar" } }
#  after_count  = User.count
#  assert_equal before_count, after_count

    end  

# ALSO:  check that a failed submission re-renders the new action

# ALSO:  Add lines to check for the appearance of error messages

# ALSO: Check for valid input yielding a new user in the DB
# assert_difference 'User.count', 1 do
#  post users_path, ...
# end

# On the /users/[#] page, could write a test to verify flash
# not to mention that we end up on that users show page

end # feature

