require 'test_helper'

class Frontend::RegistrationControllerTest < ActionController::TestCase
  def setup
    @params = { :club => clubs(:vtk).internal_name.downcase }
    @member = members(:javache)
    @session = { :member_id => @member.id }
  end

  test "should get index" do
    get :index, @params
    assert_response :success
  end

  test "should get general" do
    get :general, @params
    assert_response :success
  end

  test "should redirect to index" do
    [:photo, :isic, :success].each do |action|
      get action, @params
      assert_response :redirect
    end
  end

  test "should get photo" do
    get :photo, @params, @session
    assert_response :success
  end

  test "should get isic" do
    get :isic, @params, @session
    assert_response :success

    attributes = [:isic_newsletter, :isic_mail_card]
    @member.update_attributes(Hash[attributes.map {|k| [k, false] }])
    post :isic, @params.merge(:member => Hash[attributes.map {|k| [k, true] }]), @session

    assert_response :redirect
    @member.reload
    attributes.each {|k| assert @member.send(k), "#{k} shoud be true" }
  end

  test "should get success" do
    get :success, @params, @session
    assert_response :success
  end

end
