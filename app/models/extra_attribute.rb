class ExtraAttribute < ActiveRecord::Base
  belongs_to :spec, :class_name => 'ExtraAttributeSpec'
  belongs_to :member

  serialize :value

  attr_accessible :value
end
