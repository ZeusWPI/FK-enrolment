class EnableCardByDefault < ActiveRecord::Migration
  def up
    change_column :cards, :enabled, :boolean, :default => true
  end

  def down
    change_column :cards, :enabled, :boolean, :default => false
  end
end
