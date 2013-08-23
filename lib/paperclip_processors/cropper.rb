module Paperclip
  class Cropper < Thumbnail
    def transformation_command
      if crop_command
        (crop_command + super.join(' ').sub(/ -crop \S+/, '')).split(' ')
      else
        super
      end
    end

    private

    def automatic_cropbox(geometry)
      aspect_ratio = @target_geometry.width /
                     @target_geometry.height
      crop = [geometry.width, geometry.height, 0, 0]
      if geometry.width / geometry.height > aspect_ratio
        crop[0] = aspect_ratio * geometry.height
        crop[2] = (geometry.width - crop[0]) / 2
      else
        crop[1] = geometry.width / aspect_ratio
        crop[3] = (geometry.height - crop[1]) / 2
      end
      crop
    end

    def crop_command
      target = @attachment.instance
      large = Geometry.from_file(@attachment.queued_for_write[:large])

      crop = [target.crop_w.to_f, target.crop_h.to_f,
              target.crop_x.to_f, target.crop_y.to_f]

      # Automaticall determine crop values
      if crop[0] == 0 || crop[1] == 0
        crop = automatic_cropbox(large)
      end

      # Scale crop values
      ratio = @current_geometry.width / large.width
      "-crop '%dx%d+%d+%d' -colorspace Gray " % crop.map { |n| (n * ratio).round }
    end
  end
end
