class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.references :club
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :ugent_nr
      t.string :sex
      t.string :phone
      t.date :date_of_birth
      t.string :home_address
      t.string :studenthome_address

      t.timestamps
    end
  end
end
