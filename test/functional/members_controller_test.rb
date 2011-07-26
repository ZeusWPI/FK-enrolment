require 'test_helper'

class MembersControllerTest < ActionController::TestCase
  setup do
    @member = members(:javache)
    @club = clubs(:wina)
  end

  test "should get index" do
    get :index, params_for_api
    assert_response :success
    assert_not_nil assigns(:members)
  end

  test "should create member" do
    assert_difference('Member.count') do
      post :create, params_for_api({ member: @member.attributes })
    end
    assert_response :success
  end

  test "should not create member" do
    assert_no_difference('Member.count') do
      post :create, params_for_api({ member: {first_name: "Pieter"}})
    end
    assert_response :unprocessable_entity
  end

  test "should show member" do
    get :show, params_for_api({ id: @member.to_param })
    assert_response :success
  end

  test "should update member" do
    update = @member.attributes.merge({first_name: "Pieter-Jan"})
    put :update, params_for_api({ id: @member.to_param, member: update })
    assert_response :success
    assert_equal "Pieter-Jan", Member.find(@member.id).first_name
  end

  test "should destroy member" do
    assert_difference('Member.count', -1) do
      delete :destroy, params_for_api({ id: @member.to_param })
    end
    assert_response :success
  end
end