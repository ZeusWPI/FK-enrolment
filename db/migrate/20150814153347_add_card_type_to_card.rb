class AddCardTypeToCard < ActiveRecord::Migration
  def up
    add_column :cards, :card_type, :string
    Card.unscoped.where(isic_status: 'none').update_all(card_type: 'fk')
    Card.unscoped.where.not(isic_status: 'none').update_all(card_type: 'isic')
    Card.where(academic_year: Member.current_academic_year, card_type: 'isic').find_each do |card|
      Member.unscoped do
        if !card.club.card_range_for(:isic).include?(card.number)
          card.number = nil
          card.save(validate: false)
        end
      end
    end
    change_column :cards, :card_type, :string, null: false
  end

  def down
    remove_column :cards, :card_type
  end
end
