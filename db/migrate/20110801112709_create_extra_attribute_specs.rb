class CreateExtraAttributeSpecs < ActiveRecord::Migration
  def change
    create_table :extra_attribute_specs do |t|
      t.references :extra_attribute
      t.string :name
      t.string :type
      t.boolean :required

      t.timestamps
    end

    change_table :clubs do |t|
      t.references :extra_attribute_spec
    end
  end
end
