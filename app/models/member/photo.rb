require 'open-uri'

module Member::Photo
  def self.included(base)
    base.has_attached_file :photo, :styles => {
      :large => { :geometry => "520x700>", :format => :jpg },
      :cropped => { :geometry => "140x200", :format => :jpg, :processors => [:Cropper] }
    }

    base.with_options if: ->(m){ m.reached_state? 'photo' } do |member|
      member.validate :photo_dimensions
      member.validates_attachment_content_type :photo,
        :content_type => ['image/jpg', 'image/jpeg', 'image/pjpeg', 'image/gif',
                          'image/png', 'image/x-png', 'image/tiff'],
        :message => "Enkel afbeeldingen zijn toegestaan"
    end


    base.attr_accessible :photo, :photo_url, :photo_base64

    # Cropping
    attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
    base.attr_accessible :crop_x, :crop_y, :crop_w, :crop_h

    # Photo url errors
    base.validate if: ->(m){ m.reached_state?('photo') } do |member|
      member.errors.add(:photo_url, member.photo_url_error) if member.photo_url_error
    end
  end

  # Download and assign the photo found at url
  def photo_base64=(image)
    return if image.blank?
    @auto_crop = true

    image = Paperclip.io_adapters.for("data:;base64,#{image}")
    image.original_filename = "snapshot.jpg"
    image.content_type = "image/jpeg"
    self.photo = image
  end

  # Empty accessor
  def photo_base64
  end

  # Download and assign the photo found at url
  attr_accessor :photo_url, :photo_url_error
  def photo_url=(url)
    @photo_url = url
    self.photo_url_error = nil
    return if url.blank?

    begin
      # Don't download longer than 10 seconds
      Timeout::timeout(10) do
        self.photo = open(url, :allow_redirections => :safe)
      end
    rescue
      self.photo_url_error = "Er trad een fout op bij het ophalen van de foto."
    end
  end

  # The photo is valid when it has been cropped, either automatically or manually
  def valid_photo?
    @auto_crop || (!crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?)
  end

  # Force cropping the photo when crop-coordinates are set
  def crop_photo
    if !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
      photo.reprocess!
    end
  end

  # Validate minimum photo size
  def photo_dimensions
    return unless photo? or not photo.dirty?

    # If an exception occurs, its probably not a valid photo
    # and a previous validator will show an error
    begin
      minimum = Paperclip::Geometry.parse(photo.styles[:cropped].geometry)
      photo_path = photo.queued_for_write[:original] || photo.path(:original)
      dimensions = Paperclip::Geometry.from_file(photo_path)

      unless dimensions.width >= minimum.width && dimensions.height >= minimum.height
        errors.add :photo, "De foto dient ten minste #{minimum.width.to_i} bij " \
          "#{minimum.height.to_i} pixels te zijn."
        self.photo = nil
      end
    rescue
    end
  end
end
