class BigIntForCardNumber < ActiveRecord::Migration
  def change
    change_column(:cards, :number, :bigint)
  end
end
