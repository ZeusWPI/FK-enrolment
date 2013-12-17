class AddAttachmentExportToClub < ActiveRecord::Migration
  def change
    add_column :clubs, :export_file_name, :string
    add_column :clubs, :export_content_type, :string
    add_column :clubs, :export_file_size, :integer
    add_column :clubs, :export_updated_at, :datetime
  end
end
