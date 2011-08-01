class ExtraAttribute < ActiveRecord::Base
  has_one :extra_attribute_spec 
  has_one :member

  serialize :values
end
