class ChangeExtraAttributeValueColumnType < ActiveRecord::Migration
  def up
    change_column :extra_attributes, :value, :text, limit: 65535
  end
  def down
    # This might cause trouble if you have strings longer
    # than 255 characters.
    change_column :extra_attributes, :value, :string
  end
end
