class AddStateToMember < ActiveRecord::Migration
  def change
    # Use complete as the default state, since the other states are only
    # useful for the frontend registration.
    add_column :members, :state, :string, default: 'complete', null: false
  end
end
