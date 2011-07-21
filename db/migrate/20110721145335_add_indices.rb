class AddIndices < ActiveRecord::Migration
  def change
    add_index :clubs, :internal_name, :unique => true
    add_index :clubs, :api_key, :unique => true

    add_index :members, :ugent_nr

    add_index :cards, :member_id
    add_index :cards, [:academic_year, :number], :unique => true
  end
end
