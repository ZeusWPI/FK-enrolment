require 'open-uri'

module Member::Photo
  def self.included(base)
    base.has_attached_file :photo, :styles => {
      :large => "520x700>",
      :cropped => { :geometry => "210x270", :format => :jpg, :processors => [:Cropper] }
    }
    base.validates_attachment_content_type :photo,
      :content_type => ['image/jpg', 'image/jpeg', 'image/pjpeg', 'image/gif', 'image/png', 'image/x-png'],
      :message => "Enkel afbeeldingen zijn toegestaan"
    base.attr_accessible :photo, :photo_url, :photo_base64

    # Cropping
    attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
    base.attr_accessible :crop_x, :crop_y, :crop_w, :crop_h
    base.after_update :crop_photo, :if => :cropping?
  end

  # Download and assign the photo found at url
  def photo_base64=(image)
    return if image.blank?

    sio = StringIO.new(Base64.decode64(image))
    sio.original_filename = "snapshot.jpg"
    sio.content_type = "image/jpeg"
    self.photo = sio
    @cropped = true
  end

  # Empty accessor
  def photo_base64
  end

  # Download and assign the photo found at url
  def photo_url=(url)
    return if url.blank?

    # don't download longer than 10 seconds
    Timeout::timeout(10) do
      # TODO: support https
      uri = URI.parse(url)
      self.photo = uri.open if uri.respond_to? :open
    end
  end

  # Empty accessor
  def photo_url
  end

  # Profile picture cropping
  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def crop_photo
    photo.reprocess!
    @cropped = true
  end

  # Check if a valid photo with the correct dimensions are present
  def valid_photo?
    @cropped || false
  end
end
