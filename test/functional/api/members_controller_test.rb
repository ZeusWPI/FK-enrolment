require 'test_helper'

class Api::MembersControllerTest < ActionController::TestCase
  setup do
    @club = clubs(:wina)
    @member = members(:javache)
  end

  test "should get index" do
    get :index, params_for_api
    assert_response :success
    assert_not_nil assigns(:members)
  end

  test "should apply filters to index" do
    get :index, params_for_api(:ugent_nr => "00800001")
    assert_response :success
    assert_equal members(:javache), assigns(:members)[0]
  end

  test "should create member" do
    attributes = @member.attributes.slice *Member.accessible_attributes
    assert_difference('Member.count') do
      post :create, params_for_api({ member: attributes })
      assert_response :success
    end
    result = JSON.parse(response.body)
    assert Member.exists? result["id"]
  end

  test "should not create member" do
    assert_no_difference('Member.count') do
      post :create, params_for_api({ member: { first_name: "Pieter" }})
      assert_response :unprocessable_entity
    end
  end

  test "should show member" do
    get :show, params_for_api({ id: @member.to_param })
    assert_response :success
  end

  test "should not show member of other club" do
    get :show, params_for_api({ id: members(:nudded).to_param })
    assert_response :forbidden
  end

  test "should update member" do
    update = { first_name: "Pieter-Jan" }
    put :update, params_for_api({ id: @member.to_param, member: update })
    assert_response :success
    assert_equal "Pieter-Jan", Member.find(@member.id).first_name
  end

  test "should destroy member" do
    assert_difference('Member.count', -1) do
      delete :destroy, params_for_api({ id: @member.to_param })
      assert_response :success
    end
  end

  test "should accept params that are not nested" do
    update = { id: @member.to_param, first_name: "Pieter-Jan" }
    put :update, params_for_api(update)
    assert_response :success
    assert_equal "Pieter-Jan", Member.find(@member.id).first_name
  end
end
