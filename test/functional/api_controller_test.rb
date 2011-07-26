require 'test_helper'

class ApiControllerTest < ActionController::TestCase
  def setup
    @club = clubs(:wina)
  end

  test "an api key is required" do
    get :test, { :format => :json }
    assert_response :forbidden
    result = JSON.parse(@response.body)
    assert result.has_key?("error")
  end

  test "should get test" do
    get :test, params_for_api
    assert_response :success
    result = JSON.parse(@response.body)
    assert_equal "ok", result["status"]
  end
end