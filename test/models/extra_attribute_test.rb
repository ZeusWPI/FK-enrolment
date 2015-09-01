# == Schema Information
#
# Table name: extra_attributes
#
#  id         :integer          not null, primary key
#  member_id  :integer
#  spec_id    :integer
#  value      :text(65535)
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class ExtraAttributeTest < ActiveSupport::TestCase
  verify_fixtures ExtraAttribute

  test "should be required if spec is required" do
    attribute = ExtraAttribute.new
    attribute.member = members(:javache)
    attribute.spec = extra_attribute_specs(:study)

    attribute.spec.required = true
    assert !attribute.valid?

    attribute.spec.required = false
    assert attribute.valid?
  end
end
