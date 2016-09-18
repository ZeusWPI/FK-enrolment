class DisablePhotoStep < ActiveRecord::Migration
  def change
    add_column :clubs, :skip_photo_step, :boolean
  end
end
