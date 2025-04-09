require "test_helper"

class DatabaseTestControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get database_test_index_url
    assert_response :success
  end
end
