require 'test_helper'

class ClubTest < ActiveSupport::TestCase
  verify_fixtures Club

  test "a club can access its cards" do
    assert clubs(:wina).cards.length > 0
  end
end
