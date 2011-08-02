class ExtraAttribute < ActiveRecord::Base
  belongs_to :spec, :class_name => 'ExtraAttributeSpec'
  belongs_to :member

  attr_accessible :value, :spec_id

  validates :value, :presence => true, :if => lambda { |m| m.spec.required }
  validates :spec_id, :presence => true
  validates_associated :spec

  # By default, always join the spec
  default_scope :include => :spec

  serialize :value
end
