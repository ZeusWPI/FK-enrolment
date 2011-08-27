class Card < ActiveRecord::Base
  belongs_to :member
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

  # By default, always join the member
  default_scope :include => :member

  scope :current, where(:academic_year => Member.current_academic_year)

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
end
