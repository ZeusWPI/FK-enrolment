require 'test_helper'

class Frontend::RegistrationControllerTest < ActionController::TestCase
  def setup
    @member = members(:javache)
    @club = clubs(:vtk)
    @params = { :club => @club.to_param }
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
    @member.enabled = false
    get :success, @params, @session
    assert_response :success

    @member.reload
    assert @member.enabled
  end

  test "should handle extra attributes correctly on multiple submits" do
    extra_attributes = [
      { :spec_id => extra_attribute_specs(:study).id, :value => "Test" },
      { :spec_id => extra_attribute_specs(:message).id, :value => "A" },
    ]
    attributes = @member.attributes.slice *Member.accessible_attributes
    attributes[:extra_attributes_attributes] = extra_attributes

    def assert_valid_response
      assert_redirected_to :controller => "registration", :action => "isic", :club => "vtk"
      assert_equal @club.extra_attributes.count, @member.extra_attributes.count

      message = @member.extra_attributes.all.find do |attribute|
        attribute.spec == extra_attribute_specs(:message)
      end
      assert_equal "A", message.value
    end

    @params[:member] = attributes
    post :general, @params
    @member = Member.last
    assert_valid_response

    # Remove message-attribute
    @params[:member][:extra_attributes_attributes].pop
    post :general, @params, {:member_id => @member.id}
    @member.reload
    assert_valid_response
  end

  test "should enforce required extra attributes" do
    # Posting without any extra_attributes
    attributes = @member.attributes.slice *Member.accessible_attributes
    post :general, @params.merge(:member => attributes)
    assert_response :success
    assert !assigns(:member).valid?
  end
end
