class Club < ActiveRecord::Base
  has_many :members
  has_many :cards, :through => :members
  has_many :extra_attributes, :class_name => 'ExtraAttributeSpec', :order => :position

  validates_presence_of :name, :full_name, :internal_name, :description, :url
  validates :registration_method, :inclusion => { :in => %w(none api website) }

  # Find clubs using a specified registration method
  def self.using(method)
    where(:registration_method => Array.wrap(method).map(&:to_s))
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

  # Hash for export (see to_json)
  def serializable_hash(options = nil)
    super((options || {}).merge({
      :only => [:name, :full_name, :url, :registration_method, :uses_isic, :range_lower, :range_upper]
    }))
  end
end
