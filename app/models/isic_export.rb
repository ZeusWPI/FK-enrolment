class IsicExport < ActiveRecord::Base
  serialize :members

  has_attached_file :photos
  has_attached_file :exports

  validates_attachment_presence :photos
  validates_attachment_presence :exports

  def self.create_export
    members = Member.joins(:cards, :club).where(:enabled => true).where('clubs.uses_isic = ? OR cards.isic_status = ?', true, 'request')
  end
end
