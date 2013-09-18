class AddIsicNameToClub < ActiveRecord::Migration
  def change
    add_column :clubs, :isic_name, :string
  end
end
