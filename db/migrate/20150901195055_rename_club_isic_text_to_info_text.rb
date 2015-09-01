class RenameClubIsicTextToInfoText < ActiveRecord::Migration
  def change
    rename_column :clubs, :isic_text, :info_text
  end
end
