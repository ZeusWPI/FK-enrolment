class AddClubAndTypeToExport < ActiveRecord::Migration
  def change
  	add_column :isic_exports, :club_id, :int
  	add_column :isic_exports, :export_type, :string
  end
end
