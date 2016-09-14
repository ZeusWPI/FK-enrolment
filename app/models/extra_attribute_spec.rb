# == Schema Information
#
# Table name: extra_attribute_specs
#
#  id         :integer          not null, primary key
#  club_id    :integer
#  name       :string
#  field_type :string
#  values     :text(65535)
#  required   :boolean
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#

class ExtraAttributeSpec < ActiveRecord::Base
  belongs_to :club

  acts_as_list :scope => :club
  serialize :values

  validates :field_type, :inclusion => { :allow_blank => true,
    :in => %w(checkbox checkbox_list checkbox_grid dropdown text textarea study groupedstudy) }

  def self.build(name, type, values = [], required = false)
    spec = new
    spec.name = name
    spec.field_type = type.to_s
    spec.values = values
    spec.required = required
    spec
  end
end
