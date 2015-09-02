require 'test_helper'

class Frontend::RegistrationControllerTest < ActionController::TestCase
  def setup
    @member = members(:siloks)
  end

  def get_wizard_step step, params = {}
    get :show, params.merge({club: @member.club, id: step}),
      {member_id: @member.id}
  end

  def post_wizard_step step, params = {}
    post :update, params.merge({club: @member.club, id: step}),
      {member_id: @member.id}
  end

  test "should redirect index" do
    get :index, {club: @member.club}
    assert_response :redirect
  end

  test "should get success" do
    get :success, {club: @member.club}
    assert_response :success
  end

  test "should get authenticate" do
    get_wizard_step :authenticate
    assert_response :success
  end

  test "should get card_type" do
    get_wizard_step :card_type
    assert_response :success
  end

  # VTK forces isic on its users.
  test "should skip card_type for VTK" do
    @member = members(:nudded)
    get_wizard_step :card_type
    assert_response :redirect
  end

  test "should get info" do
    get_wizard_step :info
    assert_response :success
  end

  test "should skip questions when there are none" do
    get_wizard_step :questions
    assert_response :redirect
  end

  test "should show questions when there are" do
    @member = members(:nudded)
    get_wizard_step :questions
    assert_response :success
  end

  test "should skip isic" do
    get_wizard_step :isic
    assert_response :redirect
  end

  test "should show isic_options when user uses isic" do
    @member = members(:nudded)
    get_wizard_step :isic
    assert_response :success
  end

  test "should skip photo" do
    get_wizard_step :photo
    assert_response :redirect
  end

  test "should show photo when user uses isic" do
    @member = members(:nudded)
    get_wizard_step :photo
    assert_response :success
  end

  test "should refuse incomplete info" do
    post_wizard_step :info, member: {first_name: ""}
    refute assigns(:member).errors.empty?
  end

  test "should refuse incomplete isic info" do
    @member = members(:nudded)
    post_wizard_step :info, member: {home_address: ""}
    refute assigns(:member).errors.empty?
  end

  test "should accept complete info" do
    post_wizard_step :info
    assert assigns(:member).errors.empty?
  end

  def extra_attributes
    [
      { 'spec_id' => extra_attribute_specs(:study).id, 'value' => "Blub" },
      { 'spec_id' => extra_attribute_specs(:message).id, 'value' => "hoi" },
    ]
  end

  test "should enforce required extra attributes" do
    @member = members(:nudded)
    # Posting without any extra_attributes
    post_wizard_step :questions
    assert_response :success
    refute assigns(:member).errors.empty?
  end

  test "should accept extra attributes" do
    @member = members(:nudded)
    post_wizard_step :questions,
      member: {extra_attributes_attributes: extra_attributes}
    assert assigns(:member).errors.empty?
    assert_response :redirect
  end

  test "shoud save extra attributes" do
    @member = members(:nudded)
    post_wizard_step :questions,
      member: {extra_attributes_attributes: extra_attributes}
    @member.reload
    assert (@member.extra_attributes.any? do |a| a.value == "Blub" end)
    assert (@member.extra_attributes.any? do |a| a.value == "hoi" end)
  end

  test "should handle extra attributes correctly on multiple submits" do
    @member = members(:nudded)

    post_wizard_step :questions,
      member: {extra_attributes_attributes: extra_attributes}

    post_wizard_step :questions,
      member: {extra_attributes_attributes: extra_attributes.pop}

    @member.reload
    assert (@member.extra_attributes.any? do |a| a.value == "hoi" end)
  end
end
