class CreateExtraAttributes < ActiveRecord::Migration
  def change
    create_table :extra_attributes do |t|
      t.references :member
      t.references :extra_attribute_spec
      t.string :value
      t.timestamps
    end
  end
end
