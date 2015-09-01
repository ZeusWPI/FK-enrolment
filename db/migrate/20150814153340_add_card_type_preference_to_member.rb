class AddCardTypePreferenceToMember < ActiveRecord::Migration
  def change
    add_column :members, :card_type_preference, :string
  end
end
