require 'test_helper'

class CardsControllerTest < ActionController::TestCase
  setup do
    @club = clubs(:wina)
    @member = members(:javache)
    @card = cards(:javache)
  end

  def params_for_api(params = {}, format = "json", club = @club)
    params[:member_id] = @member.id unless params[:member_id]
    super(params, format, club)
  end

  test "should create card" do
    card = @card.dup
    card.academic_year = 2010
    card.number = 11109

    assert_difference('Card.count') do
      post :create, params_for_api({ card: card.attributes })
    end
    assert_response :success
  end

  test "should not create card" do
    assert_no_difference('Card.count') do
      post :create, params_for_api({ card: @card.dup.attributes })
    end
    assert_response :unprocessable_entity
  end

  test "should show card" do
    get :show, params_for_api({ id: @card.to_param })
    assert_response :success
  end

  test "should update card" do
    update = @card.attributes.merge({isic_status: "requested"})
    put :update, params_for_api({ id: @card.to_param, card: update })
    assert_response :success
    assert_equal "requested", Card.find(@card.id).isic_status
  end

  test "should destroy card" do
    assert_difference('Card.count', -1) do
      delete :destroy, params_for_api({ id: @card.to_param })
    end
    assert_response :success
  end
end
