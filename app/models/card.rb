# == Schema Information
#
# Table name: cards
#
#  id            :integer          not null, primary key
#  member_id     :integer
#  academic_year :integer
#  number        :integer
#  status        :string           default("unpaid")
#  enabled       :boolean          default(TRUE)
#  created_at    :datetime
#  updated_at    :datetime
#  isic_status   :string           default("none")
#  isic_number   :string
#  isic_exported :boolean          default(FALSE)
#  card_type     :string           not null
#

class Card < ActiveRecord::Base
  belongs_to :member
  has_one :club, :through => :member

  attr_accessible :number, :status, :isic_status, :card_type

  # Associated member
  validates :member, :presence => true

  # Validation rules
  validates :academic_year, :presence => true, :uniqueness => { :scope => :member_id }
  validates :number, :presence => true, :uniqueness => { :scope => :academic_year }
  validates :card_type, :presence => true, :inclusion => { :in => %w(fk isic) }
  validates :status, :inclusion => { :in => %w(unpaid paid) }
  validates :isic_status, :inclusion => { :in => %w(none request requested printed) }

  validate :number, :valid_card_number
  validate :card_type, :valid_card_type
  validates_associated :member

  # By default, always join the member
  default_scope { includes(:member) }

  scope :current, -> { where :academic_year => Member.current_academic_year }

  # Check if the assigned number falls in the range given by the club
  def valid_card_number
    return if self.number.blank? or not self.member

    # Only check the rules of current cards
    if self.academic_year == Member.current_academic_year
      range = self.club.card_range_for self.card_type
      if !range.include?(self.number)
        errors.add(:number, "valt niet in het toegekende bereik")
      end
    end
  end

  # Check whether parent club allows this card type
  def valid_card_type
    return if self.card_type.blank? or not self.member
    if !(self.club.uses_card_type?(self.card_type))
      errors.add(:kaarttype, "wordt niet toegelaten door deze club")
    end
  end

  def isic?
    self.card_type == 'isic'
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
    return if !self.isic?
    raise "Record is not new, won't change status" unless new_record?
    raise "No member associated yet" unless member
    self.isic_status = 'request'
  end

  # Force generating numbers for ISIC registrations
  before_validation :generate_number

  # Generate a fk number for an isic card.
  def generate_number
    return if !self.number.blank? || !self.isic?

    range = self.club.card_range_for :isic
    current_max = Card.where(
      :members => { :club_id => self.club.id },
      :number => range
    ).maximum(:number)
    self.number = current_max.try(:succ) || range.begin
  end

  # Export info to ISIC
  def export_to_isic
    return if !self.isic?
    IsicExport.new.submit(self.member, self)
  end

  def self.build_for member, attributes = {}
    p attributes
    card = member.build_current_card attributes
    card.card_type ||= member.pick_card_type
    card.determine_isic_status
    return card
  end
end
