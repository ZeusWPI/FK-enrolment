# Generate excel-export
class ExcelExport
  def self.create(members)
    export = ExcelExport.new
    export.add_members(members)
    export.to_s
  end

  def initialize
    @export = Spreadsheet::Workbook.new
    @sheet = @export.create_worksheet :name => 'Leden'
    @sheet.row(0).concat ['Kring', 'Voornaam', 'Familienaam', 'Geslacht',
      'UGent-nummer', 'E-mailadres', 'Geboortedatum', 'Thuisadres', 'Kotadres',
      'Foto', 'Geregistreerd', 'Kaartnummer', 'Status', 'ISIC status']
  end

  def add_members(members)
    return if members.length == 0

    club = members.first.club
    members.each_with_index do |member, i|
      card = member.current_card || Card.new
      @sheet.row(i+1).concat [club.name, member.first_name, member.last_name,
        member.sex, member.ugent_nr, member.email, member.date_of_birth,
        member.home_street.to_s + "\n" + member.home_postal_code.to_s + ' ' + member.home_city.to_s,
        member.studenthome_street.to_s + "\n" + member.studenthome_postal_code.to_s + ' ' + member.studenthome_city.to_s,
        member.photo.url(:cropped, use_timestamp = false), member.created_at,
        card.number, card.status, card.isic_status]
    end

    # Extra attributes
    club.extra_attributes.each do |spec|
      next if spec.field_type.blank?
      @sheet.row(0).concat [spec.name]
    end
    members.each_with_index do |member, i|
      attributes = []
      club.extra_attributes.each do |spec|
        next if spec.field_type.blank?
        attributes << encode_attribute(spec, member.extra_attributes)
      end
      @sheet.row(i+1).concat attributes
    end
  end

  def to_s
    io = StringIO.new
    @export.write io
    io.string
  end

  private

  def encode_attribute(spec, attributes)
    attribute = attributes.find {|attr| attr.spec_id == spec.id }
    if attribute
      if attribute.value.class.include?(Enumerable)
        return attribute.value.delete_if { |v| v.blank? }.join(', ')
      else
        return attribute.value.sub("\r\n", "\n")
      end
    else
      return ''
    end
  end
end
