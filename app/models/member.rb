# encoding: utf-8
class Member < ActiveRecord::Base
  belongs_to :club
  has_many :cards
  has_many :extra_attributes, :dependent => :destroy

  accepts_nested_attributes_for :extra_attributes
  attr_accessible :first_name, :last_name, :email, :ugent_nr, :sex, :phone,
    :date_of_birth, :home_address, :studenthome_address,
    :isic_newsletter, :isic_mail_card, :extra_attributes_attributes, :street,
    :city, :postal_code

  # Profile picture
  include Member::Photo

  # Associated club
  validates :club_id, :presence => true
  validates_associated :club

  # Validation rules
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :email, :presence => true,
                    :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i },
                    :if => lambda { |m| m.club.registration_method != "api" if m.club }
  validates :ugent_nr, :presence => true # TODO: required if not chosen for email registration
  validates :sex, :inclusion => { :in => %w(m f), :allow_blank => true }
  validates :date_of_birth, :presence => true, :if => lambda { |m| m.club.uses_isic if m.club }
  validates :home_street, :presence => true, :if => lambda { |m| m.club.uses_isic if m.club }
  validates :home_postal_code, :presence => true, :if => lambda { |m| m.club.uses_isic if m.club }
  validates :home_city, :presence => true, :if => lambda { |m| m.club.uses_isic if m.club }

  # Handy defaults
  after_initialize :defaults
  def defaults
    if self.new_record?
      # Opt-in by default for ISIC-clubs
      self.isic_newsletter = true if isic_newsletter.nil? && club.try(:uses_isic)
    end
  end

  before_save do
    self.last_registration = Member.current_academic_year
  end

  # Current academic year
  def self.current_academic_year
    # registrations end in june
    (Time.now - 6.months).year
  end

  has_one :current_card, :class_name => "Card",
    :conditions => { :academic_year => current_academic_year }

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

  # Find a previous member record, given a current student ID
  def self.member_for_ugent_nr(ugent_nr, club)
    result = Member.joins(:cards)
                   .select('members.*, COUNT(cards.id) as card_count')
                   .where(:ugent_nr => ugent_nr, :club_id => club.id,
                          :cards => { :enabled => true })
                   .order('card_count DESC, updated_at DESC')
                   .first
    result.id ? result : nil
  end

  def self.active_registrations
    where(:last_registration => self.current_academic_year)
  end

  # Hash for export (see to_json)
  def serializable_hash(options = nil)
    result = super((options || {}).merge({
      :except => [:club_id, :photo_content_type, :photo_file_name,
                  :photo_file_size, :photo_updated_at, :enabled],
      :include => [:current_card]
    }))
    result[:card] = result.delete :current_card
    result[:photo] = photo.url(:cropped) if photo?

    unless result[:card]
      card = Card.new
      card.member = self
      card.determine_isic_status if club.uses_isic
      result[:card] = card
    end

    result
  end

  # Create empty attributes for each extra-value specification and merge existing ones
  def build_extra_attributes
    map = Hash[extra_attributes.map { |k| [k.spec_id, k] }]

    # Add any attributes that do not exist yet
    club.extra_attributes.each do |spec|
      next if spec.field_type.blank?

      if !map[spec.id]
        map[spec.id] = ExtraAttribute.new
        extra_attributes << map[spec.id]
      end

      # Set the relation = a relation less that needs to be queried later
      map[spec.id].spec = spec
    end

    # Keep them in order
    # TODO: delete attributes that do not exist in club.extra_attributes
    extra_attributes.sort_by! { |a| a.spec.position }
  end

  # Assign extra_attributes to the corresponding attribute with the right spec
  def extra_attributes_attributes=(attributes)
    map = Hash[extra_attributes.map { |k| [k.spec_id, k] }]
    method = attributes.respond_to?(:each_value) ? :each_value : :each
    attributes.send(method) do |attribute|
      if attribute[:spec_id] && map[attribute[:spec_id].to_i]
        map[attribute[:spec_id].to_i].value = attribute[:value]
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

  # Shortcut for card number
  def card_number
    self.current_card ? self.current_card.number : "∅"
  end
end
