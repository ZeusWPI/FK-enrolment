class ExtraAttributeSpec < ActiveRecord::Base
  belongs_to :extra_attribute
  belongs_to :club

  serialize :values
end
