require 'test_helper'

class Backend::MembersControllerTest < ActionController::TestCase
  setup do
    @session = {:cas_user => "pdbaets", :club => "Wina"}
    @member = members(:javache)
  end

  test "payment should only accept valid card numbers" do
    @member.current_card.delete
    post :pay, {:id => @member.id, :card => {:number => 32}}, @session

    @member.reload
    assert_response :success
    assert_nil @member.current_card
  end
end
