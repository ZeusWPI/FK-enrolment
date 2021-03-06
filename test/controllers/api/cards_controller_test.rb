require 'test_helper'

class Api::CardsControllerTest < ActionController::TestCase
  setup do
    @club = clubs(:fsk)
    @member = members(:siloks)
    @card = cards(:siloks)
  end

  def params_for_api(params = {}, format = "json", club = @club)
    params[:member_id] ||= @member.id
    super(params, format, club)
  end

  test "should show card" do
    get :show, params_for_api
    assert_response :success
  end

  test "should generate new values for non-existing card" do
    @card.destroy
    get :show, params_for_api
    assert_response :success
  end

  test "should create fk card" do
    @card.destroy
    assert_difference('Card.count') do
      card_number = self.class.generate_card_number(@club, 20)
      post :create, params_for_api({card: { number: card_number, status: "paid" }})
      assert_response :success
      assert @member.current_card.card_type == 'fk'
    end
  end

  test "should create isic card" do
    @card.destroy
    assert_difference('Card.count') do
      post :create, params_for_api({card: { card_type: 'isic', status: "paid" }})
      assert_response :success
      assert @member.current_card.card_type == 'isic'
    end
  end

  test "should not create card" do
    assert_no_difference('Card.count') do
      post :create, params_for_api({ card: { status: "lol" }})
      assert_response :unprocessable_entity
    end
  end

  test "should update card" do
    post :create, params_for_api({ card: { isic_status: "requested" }})
    assert_response :success
    assert_equal "requested", @card.reload.isic_status
  end

  test "should not error on a post-action without api-key" do
    post :create, { member_id: @member.id, number: 52, format: "json" }
    assert_response :forbidden
  end

  test "should wrap params in JSON request" do
    @request.env['CONTENT_TYPE'] = 'application/json'
    post :create, params_for_api({ isic_status: "requested" })
    assert_response :success
    assert_equal "requested", @card.reload.isic_status
  end

  test "should be able to process params not in the card hash" do
    post :create, params_for_api({ isic_status: "requested" })
    assert_response :success
    assert_equal "requested", @card.reload.isic_status
  end
end
