class CreateIsicExports < ActiveRecord::Migration
  def change
    create_table :isic_exports do |t|
      t.string :status, :default => 'requested'
      t.text :members
      t.string :photos_file_name
      t.string :exports_file_name

      t.timestamps
    end
  end
end
