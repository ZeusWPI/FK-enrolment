class AddStateToMember < ActiveRecord::Migration
  def change
    # Use complete as the default state, since the other states are only
    # useful for the frontend registration.
    add_column :members, :state, :string, default: 'complete', null: false
    Member.find_each do |member|
      member.state = 'complete'
      member.save(validate: false)
    end
  end
end
