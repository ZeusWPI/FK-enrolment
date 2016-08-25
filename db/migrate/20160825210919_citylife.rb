class Citylife < ActiveRecord::Migration
  def change
    add_column :clubs, :uses_city_life, :boolean, default: false, null: false
  end
end
