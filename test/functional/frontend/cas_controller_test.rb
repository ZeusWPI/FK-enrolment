require 'test_helper'

class Frontend::CasControllerTest < ActionController::TestCase
  test "should auth user" do
    get :auth, :redirect => "/target"
    assert_response :redirect

    RubyCAS::Filter.fake("pdbaets")
    get :verify
    assert_response :redirect
    assert_redirected_to "/target"
    assert_equal "pdbaets", session[:cas_user]
  end
end
