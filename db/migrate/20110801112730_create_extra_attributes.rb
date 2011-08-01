class CreateExtraAttributes < ActiveRecord::Migration
  def change
    create_table :extra_attributes do |t|
      t.references :extra_attribute_spec
      t.timestamps
    end
    
    change_table :member do |t|
      t.references :extra_attribute
    end
  end
end
