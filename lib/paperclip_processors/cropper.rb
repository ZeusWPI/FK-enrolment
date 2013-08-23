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
      large = Geometry.from_file(@attachment.queued_for_write[:large])

      crop = [target.crop_w.to_f, target.crop_h.to_f,
              target.crop_x.to_f, target.crop_y.to_f]

      # Automaticall determine crop values
      if crop[0] == 0 || crop[1] == 0
        aspect_ratio = @target_geometry.width /
                       @target_geometry.height
        if large.width / large.height > aspect_ratio
          crop[0] = aspect_ratio * large.height
          crop[1] = large.height
          crop[2] = (large.width - crop[0]) / 2
          crop[3] = 0
        else
          crop[0] = large.width
          crop[1] = large.width / aspect_ratio
          crop[2] = 0
          crop[3] = (large.height - crop[1]) / 2
        end
      end

      # Scale crop values
      ratio = @current_geometry.width / large.width
      "-crop '%dx%d+%d+%d' -colorspace Gray " % crop.map { |n| (n * ratio).round }
    end
  end
end
