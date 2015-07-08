# == Schema Information
#
# Table name: extra_attributes
#
#  id         :integer          not null, primary key
#  member_id  :integer
#  spec_id    :integer
#  value      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class ExtraAttributeTest < ActiveSupport::TestCase
  verify_fixtures ExtraAttribute

  test "should be required if spec is required" do
    attribute = ExtraAttribute.new
    attribute.spec = extra_attribute_specs(:study)

    attribute.spec.required = true
    assert !attribute.valid?

    attribute.spec.required = false
    assert attribute.valid?
  end
end
