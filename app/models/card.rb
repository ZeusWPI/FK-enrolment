class Card < ActiveRecord::Base
  belongs_to :member
  # for some reason, using self.club triggers an update to club, so don't use it
  has_one :club, :through => :member

  attr_accessible :number, :status, :isic_status

  # Associated member
  validates :member_id, :presence => true
  validates_associated :member

  # Validation rules
  validates :academic_year, :presence => true, :uniqueness => { :scope => :member_id }
  validates :number, :presence => true, :uniqueness => { :scope => :academic_year }
  validates :status, :inclusion => { :in => %w(unpaid paid) }
  validates :isic_status, :inclusion => { :in => %w(none request requested revalidate revalidated) }
  validate :number, :valid_card_number

  # By default, always join the member
  default_scope :include => :member

  scope :current, where(:academic_year => Member.current_academic_year)

  # Check if the assigned number falls in the range given by the club
  # TODO: only check the ranges for cards currently being issued
  # as these assignments might change
  def valid_card_number
    return if self.number.blank? or not self.member
    range = self.member.club.range_lower..self.member.club.range_upper
    errors.add(:number, "valt niet in het toegekende bereik") unless range.include? self.number
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
      prev_card = prev_member.cards.where(:academic_year => prev_member.last_registration - 1)
      if prev_card
        self.isic_status = 'revalidate'
        self.isic_number = prev_card.first.isic_number
      end
    end
  end

  # Force generating numbers for ISIC registrations
  before_validation :generate_number

  # Get the next available card number
  def generate_number
    return if !self.number.blank? || self.isic_status == 'none'
    next_number = Card.where(
      :members => {:club_id => member.club_id},
      :academic_year => Member.current_academic_year
    ).maximum(:number)
    self.number = next_number ? next_number + 1 : club.range_lower
  end
end
