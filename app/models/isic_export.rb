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
    members = self.full_members

    # assign cards to all members
    members.each do |member|
      card = member.current_card
      if not card
        card = Card.new
        card.member = member
        card.determine_isic_status
      end

      if card.isic_status == 'request'
        card.isic_status = 'requested'
      elsif card.isic_status == 'revalidate'
        # Don't do anything
      else
        raise "Unable to handle isic_status #{member.current_card.isic_status}"
      end

      # TODO: don't handle cards that were not in the original request

      card.isic_exported = 1
      card.save!
      member.reload
    end

    filename = File.join(Dir.tmpdir, "Export %s" % Time.now.strftime('%F %T'))
    generate_data_spreadsheet(filename + ".xls", members)
    generate_photos_zip(filename + ".zip", members)
    save!
  end

  # Create data file
  def generate_data_spreadsheet(filename, members)
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet :name => "Gegevens"
    sheet.row(0).concat ["School", "Kring", "Voornaam", "Familienaam",
        "Geboortedatum", "E-mailadres", "Thuisadres", "FK-nummer", "Foto",
        "ISIC status", "ISIC nieuwsbrief", "Kaart opsturen"]

    members.each_with_index do |member, i|
      sheet.row(i+1).concat ["UGent", member.club.internal_name,
          member.first_name, member.last_name, member.date_of_birth, member.email,
          member.home_address.sub("\r\n", "\n"), member.current_card.number,
          "#{member.id}.jpg", member.current_card.isic_status, member.isic_newsletter,
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
