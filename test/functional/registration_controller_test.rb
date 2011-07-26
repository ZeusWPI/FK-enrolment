require 'test_helper'

class RegistrationControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get general" do
    get :general
    assert_response :success
  end

  test "should get photo" do
    get :photo
    assert_response :success
  end

  test "should get isic" do
    get :isic
    assert_response :success
  end

  test "should get success" do
    get :success
    assert_response :success
  end

end
