class Card < ActiveRecord::Base
  belongs_to :member

  # Associated member
  validates :member_id, :presence => true
  validates_associated :member

  # Validation rules
  validates :academic_year, :presence => true, :uniqueness => { :scope => :member_id }
  validates :number, :presence => true, :uniqueness => { :scope => :academic_year }
  validates :status, :inclusion => { :in => %w(unpaid paid) }
  validates :isic_status, :inclusion => { :in => %w(none requested delivered) }

  # Renders the academic year in a more commonly used format
  def full_academic_year
    unless academic_year.blank?
      academic_year.to_s + '-' + (academic_year + 1).to_s
    end
  end
end
