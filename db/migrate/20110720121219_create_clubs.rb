class CreateClubs < ActiveRecord::Migration
  def change
    create_table :clubs do |t|
      t.string :name
      t.boolean :uses_isic
      t.text :isic_text
      t.string :api_key

      t.timestamps
    end
  end
end
