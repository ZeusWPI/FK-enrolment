require 'test_helper'

class Frontend::RegistrationControllerTest < ActionController::TestCase
  def setup
    @member = members(:siloks)
    @club = clubs(:fsk)
  end

  def setup_wizard_request step
    @session ||= { member: @member.attributes.merge(
      {'extra_attributes_attributes' => @member.extra_attributes_attributes})}
    @params ||= { member: @member_params}
    @params.merge!({ club: @club, id: step })
  end

  def get_wizard_step step
    setup_wizard_request step
    get :show, @params, @session
  end

  def post_wizard_step step
    setup_wizard_request step
    post :update, @params, @session
  end

  # change club in route and member
  def set_club club
    @club = club
    @member.club = club
  end

  test "should redirect index" do
    get :index, {club: @club}
    assert_response :redirect
  end

  test "should get success" do
    get :success, {club: @club}
    assert_response :success
  end

  test "should get authenticate" do
    get_wizard_step :authenticate
    assert_response :success

  end

  test "should get isic" do
    get_wizard_step :isic
    assert_response :success
  end

  test "should skip isic for VTK" do
    @club = clubs(:vtk)
    get_wizard_step :isic
    assert_response :redirect
  end

  test "should get info" do
    get_wizard_step :info
    assert_response :success
  end

  test "should skip isic_options" do
    get_wizard_step :isic_options
    assert_response :redirect
  end

  test "should show isic_options when user desires isic" do
    @member.card_type_preference = 'isic'
    get_wizard_step :isic_options
    assert_response :success
  end

  test "should skip photo" do
    get_wizard_step :photo
    assert_response :redirect
  end

  test "should show photo when user desires isic" do
    @member.card_type_preference = 'isic'
    get_wizard_step :photo
    assert_response :success
  end

  test "should refuse incomplete info" do
    @member.first_name = ""
    post_wizard_step :info
    refute assigns(:member).errors.empty?
  end

  test "should refuse incomplete isic info" do
    @member.sex = nil
    @member.card_type_preference = 'isic'
    post_wizard_step :info
    refute assigns(:member).errors.empty?
  end

  test "should accept complete info" do
    @member.first_name = ""
    @member.last_name = ""
    @member_params = {first_name: "hoi", last_name: "test"}
    post_wizard_step :info
    assert assigns(:member).errors.empty?
  end

  test "stores partial member in session" do
    @member.first_name = ""
    @member.last_name = ""
    @member_params = {first_name: "hoi", last_name: "test"}
    post_wizard_step :info
    # Random samples
    assert_equal session[:member]["first_name"], "hoi"
    assert_equal session[:member]["last_name"], "test"
  end

  #test "should get isic" do
    #get_wizard_step :isic
    #assert_response :success

    #attributes = [:isic_newsletter, :isic_mail_card]
    #@member.update_attributes(Hash[attributes.map {|k| [k, false] }])
    #post :isic, @params.merge(:member => Hash[attributes.map {|k| [k, true] }]), @session

    #assert_response :redirect
    #@member.reload
    #attributes.each {|k| assert @member.send(k), "#{k} shoud be true" }
  #end



  def extra_attributes
    [
      { 'spec_id' => extra_attribute_specs(:study).id, 'value' => "Test" },
      { 'spec_id' => extra_attribute_specs(:message).id, 'value' => "A" },
    ]
  end

  def extra_attr_hash_equals fst, snd
    fst['spec_id'] == snd['spec_id'] && fst['value'] == snd['value']
  end

  test "should enforce required extra attributes" do
    set_club clubs(:vtk)
    # Posting without any extra_attributes
    post_wizard_step :info
    assert_response :success
    refute assigns(:member).errors.empty?
  end

  test "should accept extra attributes" do
    @club = clubs(:vtk)
    @member_params = {extra_attributes_attributes: extra_attributes}
    post_wizard_step :info
    assert assigns(:member).errors.empty?
    assert_response :redirect
  end

  def check_extra_attributes_in_session
    extra_attrs = session[:member]['extra_attributes_attributes']
    refute extra_attrs.nil?
    assert extra_attrs.any? do |a|
      extra_attr_hash_equals a, extra_attributes.last
    end
  end

  test "extra attributes should be saved to session" do
    set_club clubs(:vtk)
    @member_params = {extra_attributes_attributes: extra_attributes}
    post_wizard_step :info
    check_extra_attributes_in_session
  end

  test "should handle extra attributes correctly on multiple submits" do
    set_club clubs(:vtk)

    @member_params = {extra_attributes_attributes: extra_attributes}
    post_wizard_step :info

    check_extra_attributes_in_session
    @session = session

    @member_params = {extra_attributes_attributes: extra_attributes.pop}
    post_wizard_step :info
    check_extra_attributes_in_session
  end

  test "should save member to database" do
    @member.first_name = "kek"
    @member.delete

    get_wizard_step :save
    assert_equal "kek", Member.last.first_name
  end

  test "should save extra attributes to database" do
    set_club clubs(:vtk)
    @member.delete

    @member.build_extra_attributes
    @member.extra_attributes_attributes = extra_attributes

    get_wizard_step :save
    refute Member.last.extra_attributes.empty?
  end
end
