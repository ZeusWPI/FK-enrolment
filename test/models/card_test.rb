# == Schema Information
#
# Table name: cards
#
#  id            :integer          not null, primary key
#  member_id     :integer
#  academic_year :integer
#  number        :integer
#  status        :string           default("unpaid")
#  enabled       :boolean          default(TRUE)
#  created_at    :datetime
#  updated_at    :datetime
#  isic_status   :string           default("none")
#  isic_number   :string
#  isic_exported :boolean          default(FALSE)
#  card_type     :text             not null
#

require 'test_helper'

class CardTest < ActiveSupport::TestCase
  verify_fixtures Card

  def generate_card_number(*args, **kwargs)
    ActiveSupport::TestCase.generate_card_number(*args, **kwargs)
  end

  test "should not allow duplicates" do
    c = Card.new card_type: 'fk'
    c.member = members(:javache)
    c.number = generate_card_number(:wina, 4689)
    assert !c.valid?

    # Not a duplicate
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

  test "a number should be generated for isic cards" do
    c = Card.build_for members(:siloks), card_type: 'isic'
    c.member = members(:siloks)
    assert_equal c.generate_number, generate_card_number(:fsk, 0, isic: true)
    c.save

    # generate next number
    c.number = nil
    assert_equal c.generate_number, generate_card_number(:fsk, 1, isic: true)
  end

  test "a card number should be automatically assigned" do
    c = Card.build_for members(:siloks), card_type: 'isic'
    c.save
    assert_not_nil c.number
  end

  test "a new card should be requested for new users" do
    cards(:javache).destroy
    c = Card.build_for members(:javache), card_type: 'isic'
    assert_equal "request", c.isic_status
    assert_nil c.isic_number
  end

  test "cards for existing users should be requested too" do
    cards(:nudded).destroy
    c = Card.build_for members(:nudded)
    assert_equal "request", c.isic_status
  end
end
