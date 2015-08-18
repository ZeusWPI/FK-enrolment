# == Schema Information
#
# Table name: clubs
#
#  id                  :integer          not null, primary key
#  name                :string
#  full_name           :string
#  internal_name       :string
#  description         :string
#  url                 :string
#  registration_method :string           default("none")
#  uses_isic           :boolean          default(FALSE)
#  isic_text           :text
#  confirmation_text   :text
#  api_key             :string
#  created_at          :datetime
#  updated_at          :datetime
#  range_lower         :integer
#  range_upper         :integer
#  isic_mail_option    :integer          default(0)
#  isic_name           :string
#  export_file_name    :string
#  export_content_type :string
#  export_file_size    :integer
#  export_updated_at   :datetime
#  export_status       :string           default("none")
#  uses_fk             :boolean          default(FALSE), not null
#

class Club < ActiveRecord::Base
  has_many :members
  has_many :cards, :through => :members
  has_many :extra_attributes, -> { order :position }, :class_name => 'ExtraAttributeSpec'

  validates_presence_of :name, :full_name, :internal_name, :description, :url
  validates :registration_method, :inclusion => { :in => %w(none api website hidden) }
  validates :isic_mail_option, :inclusion => { :in => 0..2 }
  validates :export_status, :inclusion => { :in => %w(none generating done) }
  validate do |club|
    if !(uses_fk || uses_isic)
      errors.add(:base, 'Er moet een kaarttype geselecteerd zijn.')
    end
  end


  default_scope { order(:full_name) }
  scope :visible, -> { where.not(:registration_method => :hidden) }

  attr_accessible :description, :isic_text, :confirmation_text,
    :registration_method, :uses_fk, :uses_isic, :isic_mail_option

  has_attached_file :export
  # Do not validate the export. We create it ourselves so we trust it
  do_not_validate_attachment_file_type :export

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

  def allowed_card_types
    ['fk', 'isic'].select do |type|
      self.attributes['uses_' + type]
    end
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

  # FK cards go in the lower half, isic cards in the upper half.
  def card_range_for type
    type = type.to_s
    range = self.card_range
    middle = range.begin + (range.end - range.begin)/2
    return range.begin..middle if type == 'fk'
    return middle.succ..range.end if type == 'isic'
  end

  # Allows url to contain internal_name as a param
  def to_param
    internal_name.downcase
  end

  # Hash for export (see to_json)
  def serializable_hash(options = nil)
    super((options || {}).merge({
      :only => [:name, :full_name, :url, :registration_method, :uses_fk, :uses_isic]
    }))
  end

  # Export excel
  def generate_xls(member_ids, academic_year)
    self.export_status = 'generating'
    self.save

    members = Member.includes({:club => :extra_attributes}, :extra_attributes).where(id: member_ids)

    ExcelExport.create(members, academic_year) do |result|
      self.export = result
      self.export_status = 'done'
      self.save!
    end

  end
  handle_asynchronously :generate_xls

end
