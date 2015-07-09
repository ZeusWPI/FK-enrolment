# == Schema Information
#
# Table name: clubs
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  full_name           :string(255)
#  internal_name       :string(255)
#  description         :string(255)
#  url                 :string(255)
#  registration_method :string(255)      default("none")
#  uses_isic           :boolean          default(FALSE)
#  isic_text           :text
#  confirmation_text   :text
#  api_key             :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  range_lower         :integer
#  range_upper         :integer
#  isic_mail_option    :integer          default(0)
#  isic_name           :string(255)
#  export_file_name    :string(255)
#  export_content_type :string(255)
#  export_file_size    :integer
#  export_updated_at   :datetime
#  export_status       :string(255)      default("none")
#

require 'excel_export'

class Club < ActiveRecord::Base
  has_many :members
  has_many :cards, :through => :members
  has_many :extra_attributes, :class_name => 'ExtraAttributeSpec', :order => :position

  validates_presence_of :name, :full_name, :internal_name, :description, :url
  validates :registration_method, :inclusion => { :in => %w(none api website hidden) }
  validates :isic_mail_option, :inclusion => { :in => 0..2 }
  validates :export_status, :inclusion => { :in => %w(none generating done) }

  has_attached_file :export

  attr_accessible :description, :isic_text, :confirmation_text,
    :registration_method, :uses_isic, :isic_mail_option,

  ISIC_MAIL_CARD_DISABLED = 0
  ISIC_MAIL_CARD_OPTIONAL = 1
  ISIC_MAIL_CARD_FORCED = 2

  # Find clubs using a specified registration method
  def self.using(method)
    where(:registration_method => Array.wrap(method).map(&:to_s))
  end

  def uses?(method)
    registration_method == method.to_s
  end

  # Get the asset path for the club's shield
  def shield_path(size = :normal)
    if size == :small
      "shields/#{internal_name}.small.jpg"
    else
      "shields/#{internal_name}.jpg"
    end
  end

  def card_range
    academic_year = Member.current_academic_year
    base_number = ((academic_year % 100) * 100 + (self.id % 100)) * 10000
    base_number .. (base_number + 9999)
  end

  # Allows url to contain internal_name as a param
  def to_param
    internal_name.downcase
  end

  # Hash for export (see to_json)
  def serializable_hash(options = nil)
    super((options || {}).merge({
      :only => [:name, :full_name, :url, :registration_method, :uses_isic]
    }))
  end

  # Export excel
  def generate_xls(member_ids)
    self.export_status = 'generating'
    self.save

    members = Member.includes({:club => :extra_attributes}, :extra_attributes).find_all_by_id(member_ids)

    ExcelExport.create(members) do |result|
      self.export = result
      self.export_status = 'done'
      self.save!
    end

  end
  #handle_asynchronously :generate_xls


end
