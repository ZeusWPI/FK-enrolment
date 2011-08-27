require 'test_helper'

class CardTest < ActiveSupport::TestCase
  verify_fixtures Card

  test "should not allow duplicates" do
    c = Card.new
    c.member = members(:javache)
    c.academic_year = 2011
    c.number = 2
    assert !c.valid?

    c.academic_year = 2010
    assert c.valid?
  end

  test "should provide full academic year" do
    assert_equal "2011-2012", cards(:javache).full_academic_year
  end

  test "a card can access its club" do
    assert_equal clubs(:wina), cards(:javache).club
  end

  test "card number should fall within the club's range" do
    c = cards(:javache)
    c.number = 99
    assert !c.valid?
  end
end
