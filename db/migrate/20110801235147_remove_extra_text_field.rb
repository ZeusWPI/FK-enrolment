class RemoveExtraTextField < ActiveRecord::Migration
  def change
    remove_column :extra_attribute_specs, :text
  end
end
