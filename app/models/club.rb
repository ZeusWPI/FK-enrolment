class Club < ActiveRecord::Base
  has_many :members
  has_many :cards, :through => :members

  # TODO: validations
end
