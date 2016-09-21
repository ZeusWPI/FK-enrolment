class CitylifeExported < ActiveRecord::Migration
  def change
    add_column :cards, :citylife_exported, :boolean
  end
end
