require 'test_helper'

class CasControllerTest < ActionController::TestCase
  test "should get auth" do
    get :auth
    assert_response :redirect

    RubyCAS::Filter.fake('pdbaets');
    get :auth
    assert_response :success
  end
end
