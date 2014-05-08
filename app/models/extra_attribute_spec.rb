# == Schema Information
#
# Table name: extra_attribute_specs
#
#  id         :integer          not null, primary key
#  club_id    :integer
#  name       :string(255)
#  field_type :string(255)
#  values     :text(65535)
#  required   :boolean
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ExtraAttributeSpec < ActiveRecord::Base
  belongs_to :club

  acts_as_list :scope => :club
  serialize :values

  validates :field_type, :inclusion => { :allow_blank => true,
    :in => %w(checkbox checkbox_list checkbox_grid dropdown text textarea study) }

  def self.build(name, type, values = [], required = false)
    spec = new
    spec.name = name
    spec.field_type = type.to_s
    spec.values = values
    spec.required = required
    spec
  end
end
