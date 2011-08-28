class AddEnabledToMembers < ActiveRecord::Migration
  def up
    add_column :members, :enabled, :boolean, :default => false

    # Enable everyone so far
    Member.joins(:club).where("clubs.uses_isic = ?", false).update_all(:enabled => true)
    Member.joins(:club).where("clubs.uses_isic = ? AND photo_file_name IS NOT NULL", true).update_all(:enabled => true)
  end

  def down
    remove_column :members, :enabled
  end
end
