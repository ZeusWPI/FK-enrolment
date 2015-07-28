require 'test_helper'

class Frontend::CasControllerTest < ActionController::TestCase
  test "should unauthorize not logged in users" do
    get :auth, :redirect => "/target"
    assert_response :redirect

    get :verify
    assert_response :unauthorized
  end

  test "should log user out" do
    get :logout
    assert_redirected_to logout_path(url: root_url)
  end
end
