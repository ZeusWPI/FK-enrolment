class CardAttributes < ActiveRecord::Migration
  def change
  	rename_column :cards, :valid, :enabled
  	add_column :cards, :isic_status, :string, :default => "none"
  end
end
