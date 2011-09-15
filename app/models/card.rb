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
  validates :isic_status, :inclusion => { :in => %w(none request requested printed delivered) }
  validate :number, :valid_card_number

  # By default, always join the member
  default_scope :include => :member

  scope :current, where(:academic_year => Member.current_academic_year)

  # Check if the assigned number falls in the range given by the club
  def valid_card_number
    return if self.number.blank?
    range = self.member.club.range_lower..self.member.club.range_upper
    errors.add(:number, "valt niet in het toegekende bereik") if not range.include? self.number
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

  # Hash for export (see to_json)
  def serializable_hash(options = nil)
    result = super((options || {}).merge({
      :except => [:member_id]
    }))
    result[:academic_year] = full_academic_year
    result
  end

  # Get the next available card number
  def generate_number(club)
    next_number = Card.where(
      :members => {:club_id => club.id}, :enabled => true,
      :academic_year => Member.current_academic_year
    ).maximum(:number)
    self.number = next_number ? next_number + 1 : club.range_lower
  end
end
