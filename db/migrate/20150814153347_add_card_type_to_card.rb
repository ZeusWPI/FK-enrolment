class AddCardTypeToCard < ActiveRecord::Migration
  def change
    add_column :cards, :card_type, :string
    Card.find_each do |card|
      card.card_type = card.isic_status == 'none' ? 'fk' : 'isic'
      card.save!
    end
    change_column :cards, :card_type, :text, null: false
  end
end
