class ExtraAttribute < ActiveRecord::Base
  belongs_to :spec, :class_name => 'ExtraAttributeSpec'
  belongs_to :member

  serialize :value

  attr_accessible :value, :spec_id

  validate :value, :presence => true, :if => Proc.new { |m| m.spec.required }
end
