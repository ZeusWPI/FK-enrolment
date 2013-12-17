class AddExportStatusToClub < ActiveRecord::Migration
  def change
    add_column :clubs, :export_status, :string
  end
end
