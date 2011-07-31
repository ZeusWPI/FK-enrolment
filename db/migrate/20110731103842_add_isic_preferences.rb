class AddIsicPreferences < ActiveRecord::Migration
  def change
  	add_column :members, :isic_newsletter, :boolean, :default => false
  	add_column :members, :isic_mail_card, :boolean, :default => false
  end
end
