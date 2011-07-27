class Member < ActiveRecord::Base
  belongs_to :club
  has_many :cards

  attr_accessible :first_name, :last_name, :email, :ugent_nr, :sex, :phone,
    :date_of_birth, :home_address, :studenthome_address

  has_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  validates_attachment_content_type :photo,
    :content_type => ['image/jpg', 'image/jpeg', 'image/pjpeg', 'image/gif', 'image/png', 'image/x-png'],
    :message => "Enkel afbeeldingen zijn toegestaan"

  validates :club_id, :presence => true
  validates_associated :club

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  # TODO: only required when saving via the webinterface
  validates :email, :presence => true,
                    :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  # TODO: depend on club-settings?
  validates :ugent_nr, :presence => true
  validates :sex, :inclusion => { :in => %w(m f) }
  # TODO: only required for ISIC
  validates :home_address, :presence => true

  def serializable_hash(options = nil)
    super((options || {}).merge({
      :except => [:club_id]
    }))
  end

  after_initialize :defaults
  def defaults
    self.date_of_birth ||= Time.now.year - 18
  end
end
