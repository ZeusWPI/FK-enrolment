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

  # Get the asset path for the club's shield
  def shield_path(size = :normal)
    if size == :small
      "shields/#{internal_name}.small.jpg"
    else
      "shields/#{internal_name}.jpg"
    end
  end
end
