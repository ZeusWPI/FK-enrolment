class CreateIsicExports < ActiveRecord::Migration
  def change
    create_table :isic_exports do |t|
      t.string :status, :default => 'requested'
      t.text :members
      t.string :data_file_name
      t.string :photos_file_name

      t.timestamps
    end
  end
end
