# encoding: utf-8
class Member < ActiveRecord::Base
  belongs_to :club
  has_many :cards
  has_many :extra_attributes, :dependent => :destroy

  accepts_nested_attributes_for :extra_attributes
  attr_accessible :first_name, :last_name, :email, :ugent_nr, :sex, :phone,
    :date_of_birth, :home_address, :studenthome_address,
    :isic_newsletter, :isic_mail_card, :extra_attributes_attributes

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
  validates :home_address, :presence => true, :if => lambda { |m| m.club.uses_isic if m.club }

  # Handy defaults
  after_initialize :defaults
  def defaults
    # Opt-in by default for ISIC-clubs
    self.isic_newsletter = true if isic_newsletter.nil? && club.try(:uses_isic)
  end

  before_save do
    self.last_registration = Member.current_academic_year
  end

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

  # Find members that need to exported to ISIC
  def self.find_all_for_isic_export(club, type)
    result = Member.includes(:current_card, :club)
                   .where(:enabled => true, :last_registration => self.current_academic_year)
    result = result.where(:club_id => club) if club

    case type
    when "request_paid"
      only_paid = true
      status = "request"
    when "request"
      only_paid = false
      status = "request"
    when "revalidated"
      only_paid = true
      status = "revalidated"
    else
      raise "Unkown ISIC export request type"
    end

    if only_paid
      result.where('cards.isic_exported = ? AND cards.isic_status = ? AND cards.status = ?',
                   false, status, :paid)
    else
      result.where('(clubs.uses_isic = ? AND cards.id IS NULL) OR ' \
                   '(cards.isic_exported = ? AND cards.isic_status = ?)',
                   true, false, status)
    end
  end

  # Current academic year
  def self.current_academic_year
    # registrations end in june
    (Time.now - 6.months).year
  end

  has_one :current_card, :class_name => "Card",
    :conditions => { :academic_year => current_academic_year }

  # Find a previous member record, given a current student ID
  def self.member_for_ugent_nr(ugent_nr, club)
    result = Member.joins(:cards)
                   .select('members.*, COUNT(cards.id) as card_count')
                   .where(:ugent_nr => ugent_nr, :club_id => club.id, :enabled => true,
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

  # Generate excel-export
  def self.export(members)
    export = Spreadsheet::Workbook.new
    sheet = export.create_worksheet :name => 'Leden'
    sheet.row(0).concat ['Kring', 'Voornaam', 'Familienaam', 'Geslacht',
      'UGent-nummer', 'E-mailadres', 'Geboortedatum', 'Thuisadres', 'Kotadres',
      'Foto', 'Geregistreerd', 'Kaartnummer', 'Status', 'ISIC status']

    if members.length > 0
      club = members.first.club
      members.each_with_index do |member, i|
        card = member.current_card || Card.new
        sheet.row(i+1).concat [club.name, member.first_name, member.last_name,
          member.sex, member.ugent_nr, member.email, member.date_of_birth,
          member.home_address.try { |a| a.sub("\r\n", "\n") },
          member.studenthome_address.try { |a| a.sub("\r\n", "\n") },
          member.photo.url(:cropped, use_timestamp = false), member.created_at,
          card.number, card.status, card.isic_status]
      end

      # Extra attributes
      club.extra_attributes.each do |spec|
        next if spec.field_type.blank?
        sheet.row(0).concat [spec.name]
      end

      members.each_with_index do |member, i|
        attributes = []
        extra_attributes = member.extra_attributes
        club.extra_attributes.each do |spec|
          next if spec.field_type.blank?
          attribute = extra_attributes.detect {|attr| attr.spec_id == spec.id }
          if attribute
            if attribute.value.class.include?(Enumerable)
              attributes << attribute.value.delete_if { |v| v.blank? }.join(', ')
            else
              attributes << attribute.value.sub("\r\n", "\n")
            end
          else
            attributes << ''
          end
        end
        sheet.row(i+1).concat attributes
      end
    end

    io = StringIO.new
    export.write io
    io.string
  end
end
