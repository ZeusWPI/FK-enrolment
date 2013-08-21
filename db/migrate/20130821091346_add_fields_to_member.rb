class AddFieldsToMember < ActiveRecord::Migration
  def change
    add_column :members, :postal_code, :string
    add_column :members, :city, :string
    add_column :members, :street, :string
  end
end
