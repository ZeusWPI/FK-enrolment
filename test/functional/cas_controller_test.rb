require 'test_helper'

class CasControllerTest < ActionController::TestCase
  test "should get auth" do
    assert_recognizes({:controller => "cas", :action => "auth"}, "cas/auth")

    get :auth
    assert_response :redirect

    RubyCAS::Filter.fake('pdbaets')
    get :auth
    assert_response :success
    assert_equal "pdbaets", session[:cas_user]
  end
end
