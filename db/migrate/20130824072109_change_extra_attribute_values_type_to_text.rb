class ChangeExtraAttributeValuesTypeToText < ActiveRecord::Migration
  def up
    change_column :extra_attribute_specs, :values, :text, :limit => 65535
  end

  def down
    change_column :extra_attribute_specs, :values, :string
  end
end
