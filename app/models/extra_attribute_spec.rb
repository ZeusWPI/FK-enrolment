class ExtraAttributeSpec < ActiveRecord::Base
  belongs_to :club

  acts_as_list :scope => :club
  serialize :values
end
