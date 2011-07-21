require 'test_helper'

class ClubTest < ActiveSupport::TestCase
  verify_fixtures Club

  test "a club can access its cards" do
    assert clubs(:wina).cards.length > 0
  end

  test "shield path lookup" do
    assert_equal 'shields/Wina.jpg', clubs(:wina).shield_path
    assert_equal 'shields/VTK.small.jpg', clubs(:vtk).shield_path(:small)
  end
end
