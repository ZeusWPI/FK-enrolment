class ExtraAttributeSpec < ActiveRecord::Base
  belongs_to :club
  has_many :values, :class_name => ExtraAttribute

  acts_as_list :scope => :club
  serialize :values
end
