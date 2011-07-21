class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.references :member
      t.integer :academic_year
      t.integer :number
      t.string :status, :default => "unpaid"
      t.boolean :valid, :default => false

      t.timestamps
    end
  end
end
