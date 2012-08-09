module Paperclip
  class Cropper < Thumbnail
    def transformation_command
      if crop_command
        (crop_command + super.join(' ').sub(/ -crop \S+/, '')).split(' ')
      else
        super
      end
    end

    def crop_command
      target = @attachment.instance
      if target.cropping?
        # Scale crop values
        ratio = Paperclip::Geometry.from_file(@attachment.path(:original)).width /
                Paperclip::Geometry.from_file(@attachment.path(:large)).width

        "-crop '%dx%d+%d+%d' -colorspace Gray " % [
          target.crop_w.to_i * ratio, target.crop_h.to_i * ratio,
          target.crop_x.to_i * ratio, target.crop_y.to_i * ratio
        ]
      end
    end
  end
end
