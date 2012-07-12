require 'test_helper'

class CardTest < ActiveSupport::TestCase
  verify_fixtures Card

  test "should not allow duplicates" do
    c = Card.new
    c.member = members(:javache)
    c.academic_year = Member.current_academic_year
    c.number = 2
    assert !c.valid?

    c.academic_year = Member.current_academic_year + 1
    assert c.valid?
  end

  test "should provide full academic year" do
    c = cards(:javache)
    c.academic_year = 2011
    assert_equal "2011-2012", c.full_academic_year
  end

  test "a card can access its club" do
    assert_equal clubs(:wina), cards(:javache).club
  end

  test "card number should fall within the club's range" do
    c = cards(:javache)
    c.number = 99
    assert !c.valid?
  end

  test "the next new number should be generated" do
    c = Card.new(:isic_status => 'request')
    c.member = members(:javache)
    assert_equal 2, c.generate_number

    c = Card.new(:isic_status => 'request')
    c.member = members(:nudded)
    assert_equal 22, c.generate_number
  end

  test "a card number should be automatically assigned" do
    c = Card.new(:isic_status => 'request')
    c.member = members(:javache)
    c.save
    assert_not_nil c.number
  end
end
