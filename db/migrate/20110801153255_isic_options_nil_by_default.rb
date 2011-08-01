class IsicOptionsNilByDefault < ActiveRecord::Migration
  def change
    change_column :members, :isic_newsletter, :boolean, :default => nil
    change_column :members, :isic_mail_card, :boolean, :default => nil
  end
end
