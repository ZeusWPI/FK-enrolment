require 'test_helper'

class CardTest < ActiveSupport::TestCase
  verify_fixtures Card

  test "A club can access its cards" do
    assert clubs(:wina).cards.length > 0
  end
end
