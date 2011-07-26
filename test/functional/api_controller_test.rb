require 'test_helper'

class ApiControllerTest < ActionController::TestCase
  test "should get test" do
    get :test, {:format => :json}
    assert_response :success
    result = JSON.parse(@response.body)
    assert_equal "ok", result["status"]
  end
end
