class Citylife < ActiveRecord::Migration
  def change
    add_column :clubs, :uses_citylife, :boolean, default: false, null: false
  end
end
