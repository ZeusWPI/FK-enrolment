class CreateExtraAttributeSpecs < ActiveRecord::Migration
  def change
    create_table :extra_attribute_specs do |t|
      t.references :club
      t.string :name
      t.string :type
      t.string :values
      t.boolean :required
      t.integer :position

      t.timestamps
    end
  end
end
