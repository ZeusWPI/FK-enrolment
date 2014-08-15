# == Schema Information
#
# Table name: cards
#
#  id            :integer          not null, primary key
#  member_id     :integer
#  academic_year :integer
#  number        :integer
#  status        :string(255)      default("unpaid")
#  enabled       :boolean          default(TRUE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  isic_status   :string(255)      default("none")
#  isic_number   :string(255)
#  isic_exported :boolean          default(FALSE)
#

require 'isic_export'

class Card < ActiveRecord::Base
  belongs_to :member
  has_one :club, :through => :member

  attr_accessible :number, :status, :isic_status

  # Associated member
  validates :member, :presence => true

  # Validation rules
  validates :academic_year, :presence => true, :uniqueness => { :scope => :member_id }
  validates :number, :presence => true, :uniqueness => { :scope => :academic_year }
  validates :status, :inclusion => { :in => %w(unpaid paid) }
  validates :isic_status, :inclusion => { :in => %w(none request requested printed) }
  validate :number, :valid_card_number

  # By default, always join the member
  default_scope :include => :member

  scope :current, where(:academic_year => Member.current_academic_year)

  # Check if the assigned number falls in the range given by the club
  def valid_card_number
    return if self.number.blank? or not self.member
    return if self.club.uses_isic

    # Only check the rules of current cards
    if self.academic_year == Member.current_academic_year
      range = self.club.card_range
      errors.add(:number, "valt niet in het toegekende bereik") unless range.include? self.number
    end
  end

  # Renders the academic year in a more commonly used format
  def full_academic_year
    unless academic_year.blank?
      academic_year.to_s + '-' + (academic_year + 1).to_s
    end
  end

  # Set some practical defaults
  after_initialize :defaults
  def defaults
    self.status ||= "unpaid"
    # registrations for the old year end in june
    self.academic_year ||= Member.current_academic_year
  end

  # Hash for export (see to_json)§
  def serializable_hash(options = nil)
    result = super((options || {}).merge({
      :except => [:member_id]
    }))
    result["academic_year"] = full_academic_year
    result
  end

  # Check if a new card should be requested
  def determine_isic_status
    raise "Record is not new, won't change status" unless new_record?
    raise "No member associated yet" unless member
    self.isic_status = 'request'
  end

  # Force generating numbers for ISIC registrations
  before_validation :generate_number

  # Get the next available card number
  def generate_number
    return if !self.number.blank? || self.isic_status == 'none'

    # new procedure
    card_range = self.club.card_range
    next_number = Card.where(
      :members => { :club_id => self.club.id },
      :number => card_range
    ).maximum(:number)
    self.number = next_number ? next_number + 1 : card_range.begin + 1
  end

  # Export info to ISIC
  def export_to_isic
    return if not self.club.uses_isic
    IsicExport.new.submit(self.member, self)
  end
end
