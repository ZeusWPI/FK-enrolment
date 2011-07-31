class Member < ActiveRecord::Base
  belongs_to :club
  has_many :cards

  attr_accessible :first_name, :last_name, :email, :ugent_nr, :sex, :phone,
    :date_of_birth, :home_address, :studenthome_address, :photo,
    :isic_newsletter, :isic_mail_card

  # Associated club
  validates :club_id, :presence => true
  validates_associated :club

  # Validation rules
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :email, :presence => true,
                    :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i },
                    :if => lambda { |m| m.club.registration_method == "website" }
  validates :ugent_nr, :presence => true  # TOOD: required depends on club settings
  validates :sex, :inclusion => { :in => %w(m f) }
  validates :home_address, :presence => true, :if => lambda { |m| m.club.uses_isic }

  # Hash for export (see to_json)
  def serializable_hash(options = nil)
    super((options || {}).merge({
      :except => [:club_id]
    }))
  end

  # Set some practical defaults
  after_initialize :defaults
  def defaults
    self.date_of_birth ||= Time.now.year - 18
  end

  # Profile picture
  has_attached_file :photo, :styles => {
    :large => "520x700>",
    :cropped => { :geometry => "210x270", :format => :jpg, :processors => [:Cropper] }
  }
  validates_attachment_content_type :photo,
    :content_type => ['image/jpg', 'image/jpeg', 'image/pjpeg', 'image/gif', 'image/png', 'image/x-png'],
    :message => "Enkel afbeeldingen zijn toegestaan"

  # Profile picture cropping
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  attr_accessible :crop_x, :crop_y, :crop_w, :crop_h

  after_update :crop_photo, :if => :cropping?
  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def crop_photo
    photo.reprocess!
  end
end
