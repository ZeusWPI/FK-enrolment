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
  validates :isic_status, :inclusion => { :in => %w(none request requested revalidate revalidated printed) }
  validate :number, :valid_card_number

  # By default, always join the member
  default_scope :include => :member

  scope :current, where(:academic_year => Member.current_academic_year)

  # Check if the assigned number falls in the range given by the club
  def valid_card_number
    return if self.number.blank? or not self.member
    return if self.club.uses_isic

    # Cards numbers copied from previous years are still allowed
    if self.isic_status == 'revalidate' or self.isic_status == 'revalidated'
      return
    end

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

    prev_member = Member.member_for_ugent_nr(member.ugent_nr, member.club)
    if prev_member
      prev_card = prev_member.cards.where(:academic_year => member.last_registration - 1).first
      if prev_card && !prev_card.isic_number.blank?
        self.isic_status = 'revalidate'
        self.isic_number = prev_card.isic_number
        self.number = prev_card.number
      end
    end
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
end
