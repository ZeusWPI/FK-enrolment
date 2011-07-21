class Member < ActiveRecord::Base
  belongs_to :club
  has_many :cards

  # TODO: validations
  validates :sex, :inclusion => {:in => %w(m f)}
end
