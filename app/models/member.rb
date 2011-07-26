class Member < ActiveRecord::Base
  belongs_to :club
  has_many :cards

  # TODO: validations
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :sex, :inclusion => {:in => %w(m f)}
  validates :email , :presence => true, :email_format => true
end
