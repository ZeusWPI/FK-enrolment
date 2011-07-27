class AddPhotoColumn < ActiveRecord::Migration
  def up
    add_column :members, :photo_file_name,    :string
    add_column :members, :photo_content_type, :string
    add_column :members, :photo_file_size,    :integer
    add_column :members, :photo_updated_at,   :datetime
  end

  def down
    remove_column :members, :photo_file_name
    remove_column :members, :photo_content_type
    remove_column :members, :photo_file_size
    remove_column :members, :photo_updated_at
  end
  
end
