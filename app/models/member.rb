# encoding: utf-8
# == Schema Information
#
# Table name: members
#
#  id                      :integer          not null, primary key
#  club_id                 :integer
#  first_name              :string
#  last_name               :string
#  email                   :string
#  ugent_nr                :string
#  sex                     :string
#  phone                   :string
#  date_of_birth           :date
#  home_address            :string
#  studenthome_address     :string
#  created_at              :datetime
#  updated_at              :datetime
#  photo_file_name         :string
#  photo_content_type      :string
#  photo_file_size         :integer
#  photo_updated_at        :datetime
#  isic_newsletter         :boolean
#  isic_mail_card          :boolean
#  enabled                 :boolean          default(FALSE)
#  last_registration       :integer
#  home_street             :string
#  home_postal_code        :string
#  home_city               :string
#  studenthome_street      :string
#  studenthome_postal_code :string
#  studenthome_city        :string
#  card_type_preference    :string
#  state                   :string           default("complete"), not null
#

class Member < ActiveRecord::Base
  belongs_to :club
  has_many :cards, :dependent => :destroy
  has_many :extra_attributes, :dependent => :destroy

  accepts_nested_attributes_for :extra_attributes
  attr_accessible :first_name, :last_name, :email, :ugent_nr, :sex, :phone,
    :date_of_birth, :home_street, :home_postal_code, :home_city,
    :studenthome_street, :studenthome_postal_code, :studenthome_city,
    :isic_newsletter, :isic_mail_card, :extra_attributes_attributes,
    :card_type_preference


  # Profile picture
  include Member::Photo


  States = ['initial', 'card_type', 'info', 'questions', 'isic', 'photo', 'complete']
  # By default, only consider complete registrations
  default_scope { where(state: 'complete') }

  # Associated club
  validates :club, :presence => true
  validates :state, :inclusion => { :in => States }
  validates :card_type_preference, :inclusion => { :in => %w(fk isic) },
    :allow_nil => true

  # Validation rules
  validates :first_name, :presence => true, if: ->(m){ m.reached_state?('info')}
  validates :last_name, :presence => true, if: ->(m){ m.reached_state?('info')}
  validates :email, :presence => true,
                    :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i },
                      :if => (lambda do |m|
                        m.reached_state?('info') &&
                        m.club && (m.club.registration_method != "api" || m.uses_isic?)
                      end)
  validates :ugent_nr, :presence => true, if: ->(m){ m.reached_state?('info') }
  validates :sex, :inclusion => { :in => %w(m f), :allow_blank => true }

  # ISIC info
  validates :sex, :presence => true,
    if: ->(m){ m.reached_state?('info') && m.uses_isic? }
  validates :date_of_birth, :presence => true,
    if: ->(m){ m.reached_state?('info') && m.uses_isic? }
  validates :home_street, :presence => true,
    if: ->(m){ m.reached_state?('info') && m.uses_isic? }
  validates :home_postal_code, :presence => true,
    if: ->(m){ m.reached_state?('info') && m.uses_isic? }
  validates :home_city, :presence => true,
    if: ->(m){ m.reached_state?('info') && m.uses_isic? }

  # Citylife info
  validates :date_of_birth, :presence => true,
            if: ->(m){ m.reached_state?('info') && m.uses_citylife? }

  # Some clubs require this information
  validates :home_street, :home_postal_code, :home_city, :sex, :phone, :date_of_birth, presence: true,
            if: ->(m){ m.reached_state?('info') && m.club.extended_require_registration_fields? }

  def reached_state? state
    States.index(self.state) >= States.index(state)
  end

  def uses_isic?
    if self.current_card
      self.current_card.isic?
    else
      pick_card_type == 'isic'
    end
  end

  def uses_citylife?
    if self.current_card
      self.current_card.citylife?
    else
      pick_card_type == 'citylife'
    end
  end

  # Handy defaults
  after_initialize :defaults
  def defaults
    if self.new_record?
      # Opt-in by default for ISIC-clubs
      self.isic_newsletter = true if isic_newsletter.nil? && club.try(:uses_isic)
    end
  end

  # TODO: find a way to disable this when doing large-scale migrations
  before_save do
    self.last_registration = Member.current_academic_year
  end

  # Current academic year
  def self.current_academic_year
    # registrations end in june
    (Time.now - 6.months).year
  end

  has_one :current_card, -> {  where(:academic_year => Member.current_academic_year) },
    :class_name => "Card",
    :inverse_of => :member

  # Load member, checking access
  def self.find_member_for_club(member_id, club)
    return [nil, :not_found] unless member_id

    member = includes(:current_card).where(:id => member_id, :enabled => true)
    if member = member.first
      member.club_id == club.id ? [member, :success] : [nil, :forbidden]
    else
      [nil, :not_found]
    end
  end

  def self.active_registrations
    where(:last_registration => self.current_academic_year)
  end

  # Hash for export (see to_json)
  def serializable_hash(options = nil)
    result = super((options || {}).merge({
      :except => [:club_id, :photo_content_type, :photo_file_name,
                  :photo_file_size, :photo_updated_at, :enabled]
    }))
    result[:photo] = photo.url(:cropped) if photo?
    result[:card] = current_card || Card.build_for(self)
    result
  end

  # Create empty attributes for each extra-value specification and merge existing ones
  def build_extra_attributes
    map = Hash[extra_attributes.map { |k| [k.spec_id, k] }]

    # Add any attributes that do not exist yet
    club.extra_attributes.each do |spec|
      if !map[spec.id]
        map[spec.id] = ExtraAttribute.new
        extra_attributes << map[spec.id]
      end

      # Set the relation = a relation less that needs to be queried later
      map[spec.id].spec = spec
    end

    # Keep them in order
    # TODO: delete attributes that do not exist in club.extra_attributes
    extra_attributes.sort_by { |s| s.spec.position }
  end

  def extra_attributes_attributes
    extra_attributes.map(&:attributes)
  end

  # Assign extra_attributes to the corresponding attribute with the right spec
  def extra_attributes_attributes=(attributes)
    map = Hash[extra_attributes.map { |k| [k.spec_id, k] }]
    method = attributes.respond_to?(:each_value) ? :each_value : :each
    attributes.send(method) do |attribute|
      if attribute['spec_id'] && map[attribute['spec_id'].to_i]
        map[attribute['spec_id'].to_i].value = attribute['value']
      end
    end
  end

  # Disable a member and any cards he has
  def disable
    self.cards.update_all(:enabled => false)
    self.update_attribute(:enabled, false)
    self
  end

  # Shortcut for full name
  def name
    "#{first_name} #{last_name}"
  end

  def pick_card_type
    [self.card_type_preference, 'fk', 'isic', 'citylife'].compact.each do |type|
      return type if self.club.allowed_card_types.include? type
    end
  end

end
