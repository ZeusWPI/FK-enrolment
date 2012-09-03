class AddIsicExportedToCards < ActiveRecord::Migration
  def change
  	add_column :cards, :isic_exported, :boolean, :default => false
  end
end
