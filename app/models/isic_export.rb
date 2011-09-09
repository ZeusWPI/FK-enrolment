class IsicExport < ActiveRecord::Base
  serialize :members

  has_attached_file :photos
  has_attached_file :exports

  validates :status, :inclusion => { :in => %w(requested printed) }
  #validates_attachment_presence :photos
  #validates_attachment_presence :exports

  def self.create_export
    members = Member.includes(:current_card, :club).where(:enabled => true).where(
      '(clubs.uses_isic = ? AND cards.id IS NULL) OR cards.isic_status = ?',
      true, 'request'
    )
    return nil if members.length == 0

    # assign cards to all members
    members.each do |member|
      if not member.current_card
        # TODO: figure out why this causes an update to Club
        card = Card.new
        card.generate_number(member.club)
        member.current_card = card
      else
        card = member.current_card
      end

      card.isic_status = 'requested'
      card.save(:validate => false)
    end

    export = IsicExport.new
    export.members = members.map(&:id)
    export.save

    file_name = "Export %s" % Time.now.strftime('%F %T')

    # create zip file for photos
    z = Zippy.create(File.join(Dir.tmpdir, file_name + ".zip")) do |zip|
      members.each do |member|
        File.open(member.photo.path) { |p| zip["#{member.id}.jpg"] = p }
      end
    end
    File.open(z.filename) { |f| export.photos = f }

    export if export.save
  end
end
