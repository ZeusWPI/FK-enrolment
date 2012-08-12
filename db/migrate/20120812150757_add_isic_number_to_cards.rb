class AddIsicNumberToCards < ActiveRecord::Migration
  def change
    add_column :cards, :isic_number, :integer
  end
end
