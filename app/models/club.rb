class Club < ActiveRecord::Base
  has_many :members
  has_many :cards, :through => :members

  validates_presence_of :name, :full_name, :internal_name, :description, :url
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

  # Allows url to contain internal_name as a param
  def to_param
    internal_name.downcase
  end
end
