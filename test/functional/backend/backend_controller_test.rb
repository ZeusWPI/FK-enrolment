require 'test_helper'

class Backend::BackendControllerTest < ActionController::TestCase
  tests Backend::HomeController

# TODO: these tests should use some stubbed fk auth service
#  test "uknown users should be denied" do
#    get :index, nil, {:cas_user => "Freddy"}
#    assert_response :forbidden
#  end
#
#  test "known users should be allowed" do
#    get :index, nil, {:cas_user => "pdbaets", :club => "Wina"}
#    assert_response :success
#  end
end
