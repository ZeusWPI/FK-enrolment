# == Schema Information
#
# Table name: clubs
#
#  id                  :integer          not null, primary key
#  name                :string
#  full_name           :string
#  internal_name       :string
#  description         :string
#  url                 :string
#  registration_method :string           default("none")
#  uses_isic           :boolean          default(FALSE)
#  isic_text           :text
#  confirmation_text   :text
#  api_key             :string
#  created_at          :datetime
#  updated_at          :datetime
#  range_lower         :integer
#  range_upper         :integer
#  isic_mail_option    :integer          default(0)
#  isic_name           :string
#  export_file_name    :string
#  export_content_type :string
#  export_file_size    :integer
#  export_updated_at   :datetime
#  export_status       :string           default("none")
#  uses_fk             :boolean          default(FALSE), not null
#

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
