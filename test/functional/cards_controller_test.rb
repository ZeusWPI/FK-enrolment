require 'test_helper'

class CardsControllerTest < ActionController::TestCase
  setup do
    @club = clubs(:wina)
    @member = members(:javache)
    @card = cards(:javache)
  end

  def params_for_api(params = {}, format = "json", club = @club)
    params[:member_id] ||= @member.id
    super(params, format, club)
  end

  test "should show card" do
    get :show, params_for_api
    assert_response :success
  end

  test "should create card" do
    @card.destroy
    assert_difference('Card.count') do
      post :update, params_for_api({ card: @card.attributes })
    end
    assert_response :success
  end

  test "should not create card" do
    assert_no_difference('Card.count') do
      post :update, params_for_api({ card: { status: "lol" }})
    end
    assert_response :unprocessable_entity
  end

  test "should update card" do
    post :update, params_for_api({ card: { isic_status: "requested" }})
    assert_response :success
    assert_equal "requested", @card.reload.isic_status
  end
end
