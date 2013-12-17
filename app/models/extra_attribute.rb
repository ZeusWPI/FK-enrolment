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

class ExtraAttribute < ActiveRecord::Base
  belongs_to :spec, :class_name => 'ExtraAttributeSpec'
  belongs_to :member

  attr_accessible :value, :spec_id

  validates :value, :presence => true, :if => lambda { |m| m.spec && m.spec.required }
  validates :spec, :presence => true

  serialize :value
end
