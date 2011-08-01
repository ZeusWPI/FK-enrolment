require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "should get index" do
    assert_recognizes({:controller => "home", :action => "index"}, "")

    get :index
    assert_response :success

    Club.all.each do |c|
      present = @response.body.include?(c.full_name)
      assert present, c.full_name
    end
  end
end
