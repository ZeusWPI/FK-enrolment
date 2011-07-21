class Club < ActiveRecord::Base
  has_many :members
  has_many :cards, :through => :members

  # TODO: validations
  validates :registration_method, :inclusion => { :in => %w(none api website) }

  class << self
    # Find clubs using a specified registration method
    def using(method)
      where(:registration_method => method.to_s)
    end
  end
end
