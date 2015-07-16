# == Schema Information
#
# Table name: clubs
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  full_name           :string(255)
#  internal_name       :string(255)
#  description         :string(255)
#  url                 :string(255)
#  registration_method :string(255)      default("none")
#  uses_isic           :boolean          default(FALSE)
#  isic_text           :text
#  confirmation_text   :text
#  api_key             :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  range_lower         :integer
#  range_upper         :integer
#  isic_mail_option    :integer          default(0)
#  isic_name           :string(255)
#  export_file_name    :string(255)
#  export_content_type :string(255)
#  export_file_size    :integer
#  export_updated_at   :datetime
#  export_status       :string           default("none")
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
