# == Schema Information
#
# Table name: cards
#
#  id            :integer          not null, primary key
#  member_id     :integer
#  academic_year :integer
#  number        :integer
#  status        :string(255)      default("unpaid")
#  enabled       :boolean          default(TRUE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  isic_status   :string(255)      default("none")
#  isic_number   :string(255)
#  isic_exported :boolean          default(FALSE)
#

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
    c.member = members(:siloks)
    assert_equal cards(:javache).number + 1, c.generate_number
  end

  test "a card number should be automatically assigned" do
    c = Card.new(:isic_status => 'request')
    c.member = members(:javache)
    c.save
    assert_not_nil c.number
  end

  test "a new card should be requested for new users" do
    cards(:javache).destroy
    c = Card.new
    c.member = members(:javache)
    c.determine_isic_status
    assert_equal "request", c.isic_status
    assert_nil c.isic_number
  end

  test "cards for existing users should be requested too" do
    cards(:nudded).destroy
    c = Card.new
    c.member = members(:nudded)
    c.determine_isic_status
    assert_equal "request", c.isic_status
  end
end
