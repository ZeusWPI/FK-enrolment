class AddPhotoColumn < ActiveRecord::Migration
  def change
    add_column :members, :photo_file_name,    :string
    add_column :members, :photo_content_type, :string
    add_column :members, :photo_file_size,    :integer
    add_column :members, :photo_updated_at,   :datetime
  end  
end
