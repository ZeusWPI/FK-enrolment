class IsicExport < ActiveRecord::Base
  serialize :members

  has_attached_file :data
  has_attached_file :photos

  validates :status, :inclusion => { :in => %w(requested printed) }

  # Get a list of members involved in this export
  def full_members
    Member.includes(:current_card, :club).where(:id => self.members, :enabled => true)
  end

  # Generate the export files
  def generate
    members = full_members

    # assign cards to all members
    members.each do |member|
      card = member.current_card
      if not card
        card = Card.new
        card.member = member
        card.determine_isic_status
      end

      card.isic_status = 'requested' if card.isic_status == 'request'

      # In this case cards might have just been generated
      if export_type == 'request' && card.isic_status != 'requested'
        self.members.delete member.id
      else
        card.isic_exported = 1
      end

      # fix duplicate card numbers
      if !card.valid?
        other_card = Card.where(:number => card.number, :academic_year => Member.current_academic_year).first!
        if !other_card.isic_exported
          other_card.number = nil
          other_card.save!
        end
      end

      card.save!
    end

    members = full_members
    club = club_id ? Club.find(club_id).internal_name : ''
    filename = File.join(Dir.tmpdir, "Export %s %s %s" % [club, export_type, Time.now.strftime('%F %T')])
    generate_data_spreadsheet(filename + ".xls", members)
    generate_photos_zip(filename + ".zip", members)
    save!
  end

  # Create data file
  def generate_data_spreadsheet(filename, members)
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet :name => "Gegevens"
    sheet.row(0).concat ["School", "Kring", "Voornaam", "Familienaam",
        "Geboortedatum", "E-mailadres", "Thuisadres",  "FK-nummer",
        "ISIC nummer", "ISIC status", "Status", "Foto", "ISIC nieuwsbrief", "Kaart opsturen"]

    members.each_with_index do |member, i|
      sheet.row(i+1).concat ["UGent", member.club.internal_name,
          member.first_name, member.last_name, member.date_of_birth, member.email,
          member.home_address.sub("\r\n", "\n"), member.current_card.number,
          member.current_card.isic_number, member.current_card.isic_status,
          member.current_card.status, "#{member.id}.jpg", member.isic_newsletter,
          member.isic_mail_card]
    end
    book.write(filename)
    assign_file_and_unlink(:data, filename)
  end

  # Create zip file for photos
  def generate_photos_zip(filename, members)
    Zippy.create(filename) do |zip|
      members.each do |member|
        if member.photo?
          File.open(member.photo.path(:cropped)) do |p|
            zip["#{member.id}.jpg"] = p
          end
        end
      end
    end
    assign_file_and_unlink(:photos, filename)
  end

private
  def assign_file_and_unlink(property, filename)
    return unless File.exists? filename

    File.open(filename) do |file|
      self.send("#{property}=", file)
    end
    File.unlink(filename)
  end
end
