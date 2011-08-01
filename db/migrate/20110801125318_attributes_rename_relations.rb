class AttributesRenameRelations < ActiveRecord::Migration
  def change
    rename_column :extra_attributes, :extra_attribute_spec_id, :spec_id
  end
end
