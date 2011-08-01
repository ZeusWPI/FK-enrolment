class AddTextFieldToExtraAttributeSpec < ActiveRecord::Migration
  def change
    change_table :extra_attribute_specs do |t|
      t.string :text
    end
  end
end
