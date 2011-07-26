class Member < ActiveRecord::Base
  belongs_to :club
  has_many :cards

  attr_accessible :first_name, :last_name, :email, :ugent_nr, :sex, :phone,
    :date_of_birth, :home_address, :studenthome_adddress

  validates :club_id, :presence => true
  validates_associated :club

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  # TODO: only required when saving via the webinterface
  validates :email, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  # TODO: depend on club-settings?
  validates :ugent_nr, :presence => true
  validates :sex, :inclusion => { :in => %w(m f) }
  # TODO: only required for ISIC
  validates :phone, :presence => true

  def serializable_hash(options = nil)
    super((options || {}).merge({
      :except => [:club_id]
    }))
  end
end
