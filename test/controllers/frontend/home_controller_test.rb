require 'test_helper'

class Frontend::HomeControllerTest < ActionController::TestCase
  test "should get index" do
    assert_recognizes({:controller => "frontend/home", :action => "index"}, "")

    get :index
    assert_response :success

    Club.all.each do |c|
      present = @response.body.include?(c.full_name)
      assert present, c.full_name
    end
  end
end
