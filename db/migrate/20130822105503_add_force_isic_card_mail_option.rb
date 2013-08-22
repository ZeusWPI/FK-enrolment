class AddForceIsicCardMailOption < ActiveRecord::Migration
  def up
    change_column :clubs, :offer_isic_mail_option, :int, :default => 0
    rename_column :clubs, :offer_isic_mail_option, :isic_mail_option
  end

  def down
    rename_column :clubs, :isic_mail_option, :offer_isic_mail_option
    change_column :clubs, :offer_isic_mail_option, :boolean, :default => false
  end
end
