class Member < ActiveRecord::Base
  belongs_to :club
  has_many :cards
  has_many :extra_attributes

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
                    :if => lambda { |m| m.club.registration_method != "api" if m.club }
  validates :ugent_nr, :presence => true  # TOOD: required if not chosen for email registration
  validates :sex, :inclusion => { :in => %w(m f) }
  validates :home_address, :presence => true, :if => lambda { |m| m.club.uses_isic if m.club }

  # Hash for export (see to_json)
  def serializable_hash(options = nil)
    result = super((options || {}).merge({
      :except => [:club_id, :isic_newsletter, :isic_mail_card,
                  :photo_content_type, :photo_file_name, :photo_file_size, :photo_updated_at],
      :include => [:current_card]
    }))
    result[:card] = result.delete :current_card
    result
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

  # Current academic year
  def self.current_academic_year
    # registrations end in june
    (Time.now - 6.months).year
  end
  has_one :current_card, :class_name => "Card",
    :conditions => { :academic_year => current_academic_year }
end
