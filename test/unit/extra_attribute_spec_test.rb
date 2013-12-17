# == Schema Information
#
# Table name: extra_attribute_specs
#
#  id         :integer          not null, primary key
#  club_id    :integer
#  name       :string(255)
#  field_type :string(255)
#  values     :text(65535)
#  required   :boolean
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class ExtraAttributeSpecTest < ActiveSupport::TestCase
  verify_fixtures ExtraAttributeSpec
end
