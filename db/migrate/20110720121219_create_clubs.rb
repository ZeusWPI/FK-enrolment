class CreateClubs < ActiveRecord::Migration
  def change
    create_table :clubs do |t|
      t.string :name
      t.string :full_name
      t.string :internal_name
      t.string :description
      t.string :url

      # settings
      t.string :registration_method
      t.boolean :uses_isic
      t.text :isic_text
      t.text :confirmation_text
      t.string :api_key

      t.timestamps
    end
  end
end
