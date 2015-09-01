class AddLastRegistrationToMember < ActiveRecord::Migration
  def up
    add_column :members, :last_registration, :integer
    Member.unscoped.update_all :last_registration => (Member.current_academic_year - 1)
  end

  def down
    remove_column :members, :last_registration
  end
end
