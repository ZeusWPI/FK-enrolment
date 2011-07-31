require 'test_helper'

class CardTest < ActiveSupport::TestCase
  verify_fixtures Card

  test "should not allow duplicates" do
    c = Card.new
    c.member = members(:javache)
    c.academic_year = 2011
    c.number = 25
    assert !c.valid?

    c.academic_year = 2010
    assert c.valid?
  end

  test "should provide full academic year" do
    assert_equal "2011-2012", cards(:javache).full_academic_year
  end
end
