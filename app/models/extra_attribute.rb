class ExtraAttribute < ActiveRecord::Base
  belongs_to :spec, :class_name => 'ExtraAttributeSpec'
  belongs_to :member

  attr_accessible :value, :spec_id

  validates :value, :presence => true, :if => lambda { |m| m.spec && m.spec.required }
  validates :spec, :presence => true

  serialize :value
end
