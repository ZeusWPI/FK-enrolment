class IsicExport < ActiveRecord::Base
  serialize :members

  has_attached_file :photos
  has_attached_file :exports

  validates :status, :inclusion => { :in => %w(requested printed) }
  validates_attachment_presence :photos
  validates_attachment_presence :exports

  def self.create_export
    members = Member.includes(:current_card, :club).where(:enabled => true).where(
      '(clubs.uses_isic = ? AND cards.id IS NULL) OR cards.isic_status = ?',
      true, 'request'
    )
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
    logger.debug export.attributes
  end
end
