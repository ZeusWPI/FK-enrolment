class ExtraAttributeSpec < ActiveRecord::Base
  belongs_to :club

  acts_as_list :scope => :club
  serialize :values

  validates :field_type, :inclusion => { :allow_blank => true,
    :in => %w(checkbox checkbox_list checkbox_grid text textarea study) }

  def self.build(name, type, values = [], required = false)
    new(:name => name, :field_type => type.to_s, :values => values, :required => required)
  end
end
