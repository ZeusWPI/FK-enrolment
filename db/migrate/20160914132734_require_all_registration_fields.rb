class RequireAllRegistrationFields < ActiveRecord::Migration
  def change
    add_column :clubs, :extended_require_registration_fields, :boolean
  end
end
