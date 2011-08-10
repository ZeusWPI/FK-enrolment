require 'test_helper'

class CasControllerTest < ActionController::TestCase
  setup do
    RubyCAS::Filter.fake(nil)
  end

  test "should auth user" do
    get :auth, :redirect => "/target"
    assert_response :redirect

    RubyCAS::Filter.fake("pdbaets")
    get :verify
    assert_response :redirect
    assert_redirected_to "/target"
    assert_equal "pdbaets", session[:cas_user]
  end

  test "should perform single-sign-out" do
    params =  {"logoutRequest" => "<samlp:LogoutRequest xmlns:samlp=\"urn:oasis:names:tc:SAML:2.0:protocol\" ID=\"LR-25247-PCqWKmp7cbsqX3s9eGmEgdeGwj4gXqoRvW5\" Version=\"2.0\" IssueInstant=\"2011-08-10T21:01:30Z\"><saml:NameID xmlns:saml=\"urn:oasis:names:tc:SAML:2.0:assertion\">@NOT_USED@</saml:NameID><samlp:SessionIndex>ST-149260-zfZ3mHobRXRrwQkSWmeL-cas</samlp:SessionIndex></samlp:LogoutRequest>"}
    post :verify, params
    assert_response :success
  end
end
