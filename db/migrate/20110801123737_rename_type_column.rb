class RenameTypeColumn < ActiveRecord::Migration
  def change
    rename_column :extra_attribute_specs, :type, :field_type
  end
end
