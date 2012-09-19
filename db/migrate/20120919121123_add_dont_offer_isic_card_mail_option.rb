class AddDontOfferIsicCardMailOption < ActiveRecord::Migration
  def change
  	add_column :clubs, :offer_isic_mail_option, :boolean, :default => true
  end
end
