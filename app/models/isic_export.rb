class IsicExport < ActiveRecord::Base
  serialize :members

  has_attached_file :photos
  has_attached_file :exports

  validates_attachment_presence :photos
  validates_attachment_presence :exports

end
