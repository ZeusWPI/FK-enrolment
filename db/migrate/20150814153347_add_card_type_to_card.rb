class AddCardTypeToCard < ActiveRecord::Migration
  def fix_isic_card_number card
    return if !card.isic? || card.academic_year != Member.current_academic_year
    Member.unscoped do
      if !card.club.card_range_for(:isic).include?(card.number)
        card.number = nil
      end
    end
  end

  def up
    add_column :cards, :card_type, :string
    Card.unscoped.find_each do |card|
      card.card_type = card.isic_status == 'none' ? 'fk' : 'isic'
      fix_isic_card_number card
      card.save(validate: false)
    end
    change_column :cards, :card_type, :text, null: false
  end

  def down
    remove_column :cards, :card_type
  end
end
