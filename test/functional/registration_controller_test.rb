require 'test_helper'

class RegistrationControllerTest < ActionController::TestCase
  def setup
    @params = { :club => clubs(:vtk).internal_name.downcase }
  end

  test "should get index" do
    get :index, @params
    assert_response :success
  end

  test "should get general" do
    get :general, @params
    assert_response :success
  end

  test "should get photo" do
    get :photo, @params
    assert_response :success
  end

  test "should get isic" do
    get :isic, @params
    assert_response :success
  end

  test "should get success" do
    get :success, @params
    assert_response :success
  end

end
