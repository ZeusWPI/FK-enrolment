# Generate excel-export
class ExcelExport
  def self.create(members)
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
