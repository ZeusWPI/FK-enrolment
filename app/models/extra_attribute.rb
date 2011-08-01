class ExtraAttribute < ActiveRecord::Base
  belongs_to :extra_attribute_spec
  belongs_to :member

  serialize :value
end
