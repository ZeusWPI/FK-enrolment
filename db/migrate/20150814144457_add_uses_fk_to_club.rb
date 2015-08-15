class AddUsesFkToClub < ActiveRecord::Migration
  def change
    add_column :clubs, :uses_fk, :boolean, default: false, null: false
    Club.find_each do |club|
      club.uses_fk = !club.uses_isic
      club.save!
    end
  end
end
