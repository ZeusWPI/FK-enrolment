class IsicExport < ActiveRecord::Base
  serialize :members

  has_attached_file :data
  has_attached_file :photos

  validates :status, :inclusion => { :in => %w(requested printed) }
  validates_attachment_presence :data
  validates_attachment_presence :photos

  def self.create_export
    members = Member.includes(:current_card, :club).where(:enabled => true).where(
      '(clubs.uses_isic = ? AND cards.id IS NULL) OR cards.isic_status = ?',
      true, 'request'
    )
    return nil if members.length == 0

    # assign cards to all members
    members.each do |member|
      if not member.current_card
        card = Card.new
        card.generate_number(member.club)
        card.isic_status = 'requested'
        member.current_card = card
      else
        card = member.current_card
        card.update_attribute(:isic_status, 'requested')
      end
    end

    export = IsicExport.new
    export.members = members.map(&:id)

    file_name = File.join(Dir.tmpdir, "Export %s.xls" % Time.now.strftime('%F %T'))

    # create data file
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet :name => "Gegevens"
    sheet.row(0).concat ["School", "Kring", "Voornaam", "Familienaam",
        "Geboortedatum", "Thuisadres", "FK-nummer", "Foto",
        "ISIC Nieuwsbrief" "Kaart opsturen"]

    members.each_with_index do |member, i|
      sheet.row(i+1).concat ["UGent", member.club.internal_name,
          member.first_name, member.last_name, member.date_of_birth,
          member.home_address.sub("\r\n", "\n"), member.current_card.number,
          "#{member.id}.jpg", member.isic_newsletter, member.isic_mail_card]
    end
    book.write(file_name)

    File.open(file_name) { |f| export.data = f }
    File.unlink(file_name)

    # create zip file for photos
    zip = Zippy.create(file_name.sub ".xls", ".zip") do |zip|
      members.each do |member|
        File.open(member.photo.path) { |p| zip["#{member.id}.jpg"] = p }
      end
    end
    File.open(zip.filename) { |f| export.photos = f }
    File.unlink(zip.filename)

    export if export.save
  end
end
