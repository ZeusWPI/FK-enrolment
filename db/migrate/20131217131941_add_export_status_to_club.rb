class AddExportStatusToClub < ActiveRecord::Migration
  def change
    add_column :clubs, :export_status, :string, :default => "none"
  end
end
