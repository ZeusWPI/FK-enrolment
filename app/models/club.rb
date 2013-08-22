class Club < ActiveRecord::Base
  has_many :members
  has_many :cards, :through => :members
  has_many :extra_attributes, :class_name => 'ExtraAttributeSpec', :order => :position

  validates_presence_of :name, :full_name, :internal_name, :description, :url
  validates :registration_method, :inclusion => { :in => %w(none api website hidden) }

  attr_accessible :description, :isic_text, :confirmation_text,
    :registration_method, :uses_isic, :isic_mail_option

  ISIC_MAIL_CARD_DISABLED = 0
  ISIC_MAIL_CARD_OPTIONAL = 1
  ISIC_MAIL_CARD_FORCED = 2

  # Find clubs using a specified registration method
  def self.using(method)
    where(:registration_method => Array.wrap(method).map(&:to_s))
  end

  def uses?(method)
    registration_method == method.to_s
  end

  # Get the asset path for the club's shield
  def shield_path(size = :normal)
    if size == :small
      "shields/#{internal_name}.small.jpg"
    else
      "shields/#{internal_name}.jpg"
    end
  end

  def card_range
    academic_year = Member.current_academic_year
    base_number = ((academic_year % 100) * 100 + (self.id % 100)) * 10000
    base_number .. (base_number + 9999)
  end

  # Allows url to contain internal_name as a param
  def to_param
    internal_name.downcase
  end

  # Hash for export (see to_json)
  def serializable_hash(options = nil)
    super((options || {}).merge({
      :only => [:name, :full_name, :url, :registration_method, :uses_isic]
    }))
  end
end
