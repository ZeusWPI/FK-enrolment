# == Schema Information
#
# Table name: extra_attribute_specs
#
#  id         :integer          not null, primary key
#  club_id    :integer
#  name       :string
#  field_type :string
#  values     :text(65535)
#  required   :boolean
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class ExtraAttributeSpecTest < ActiveSupport::TestCase
  verify_fixtures ExtraAttributeSpec
end
