class BasicMemberReport
  include Datagrid

  extend ActionView::Helpers::UrlHelper
  extend ActionView::Helpers::TagHelper
  extend ApplicationHelper

  class << self
    include Rails.application.routes.url_helpers
  end

  scope do
    Member.includes(:current_card)
          .active_registrations.where({:enabled => true})
          .order("members.created_at DESC")
  end

  # Filters
  filter(:club_id, :integer)
  filter(:first_name) do |value|
    self.where(["LOWER(members.first_name) LIKE ?", "%#{value.downcase}%"])
  end
  filter(:last_name) do |value|
    self.where(["LOWER(members.last_name) LIKE ?", "%#{value.downcase}%"])
  end
  filter(:ugent_nr)
  filter(:email) do |value|
    self.where(["LOWER(members.email) LIKE ?", "%#{value.downcase}%"])
  end
  filter(:card_number) do |value|
    self.where(["cards.number = ?", value])
  end
  filter(:card_holders_only, :boolean) do |value|
    self.where(["cards.number IS NOT NULL"])
  end

  # Columns
  column(:name, :order => "last_name, first_name" ,:header => "Naam") do |member|
    member.last_name + ", " + member.first_name
  end
  column(:ugent_nr, :header => "UGent-nr.")
  column(:email, :header => "E-mailadres")
  column(:card_number, :header => "FK-nummer")
  column(:created_at, :order => "members.updated_at", :header => "Laatst gewijzigd") do |member|
    I18n.localize member.updated_at, :format => :medium
  end
  column(:photo, :header => "") do |member|
    if member.photo?
      icon(:photo, '', photo_backend_member_path(member),
        "data-photo" => member.photo(:cropped))
    else
      icon(:nophoto, '', photo_backend_member_path(member))
    end
  end
end
