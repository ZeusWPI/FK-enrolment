class Backend::MembersController < Backend::BackendController
  before_filter :load_member, :except => [:index, :search]
  def load_member
    @member, status = Member.find_member_for_club(params['id'], @club)
    if not @member
      redirect_to backend_members_path, :error => "Ongeldig lid."
    end
  end

  def index
    report_params = {:club_id => @club.id}
    @filtered = false
    if params[:member_report]
      # This will check if members are actually filtered
      params[:member_report].each do |key, value| 
        next if key == "order" || key == "descending" || key == "club_id"
        if key == "card_holders_only" && value == "true"
          @filtered = true
          break
        end
        if value != ""
          @filtered = true
          break
        end
      end
      # This order will guarantee club_id cannot be set from the outside
      report_params = params[:member_report].merge(report_params)
    end
    @membergrid = MemberReport.new(report_params)
    @members = @membergrid.assets.paginate(:page => params[:page], :per_page => 1)

    attributes = {:club_id => @club, :enabled => true}
    @registered_members = Member.where(attributes).count
    @card_members = Member.where(attributes).joins(:current_card).count
  end

  def disable
    @member.disable
    redirect_to backend_members_path, :success => "#{@member.name} werd verwijderd."
  end

  def show
    # Load extra attributes with specs
    @extra_attributes = @member.extra_attributes.includes(:spec).all
  end

  def search
    case params[:search_field]
    when 'ugent_nr'
      @members = Member.where(:ugent_nr => params[:search_value])
    when 'email'
      @members = Member.where(:email => params[:search_value])
    when 'name'
      @members = Member.where('LOWER(first_name || " " || last_name) LIKE ?', "%#{params[:search_value].downcase}%")
    end
    respond_to do |format|
      format.js
    end
  end

  def pay
    @card = @member.current_card
    unless @card
      @card = Card.new(:status => 'unpaid', :isic_status => (@member.club.uses_isic ? 'request' : 'none'))
      @card.member = @member
    end
    if params[:card]
      @card.update_attributes(params[:card])
      unless @card.save
        @card.number = nil
      end
    end
  end

  class MemberReport
    include Datagrid
    extend ActionView::Helpers::UrlHelper
    extend ActionView::Helpers::TagHelper
    extend ApplicationHelper
    class << self
      include Rails.application.routes.url_helpers
    end

    scope do
      Member.includes(:current_card).where({:enabled => true}).order("members.created_at DESC")
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
    column(:created_at, :order => "members.created_at", :header => "Geregistreerd") do |member|
      I18n.localize member.created_at, :format => :short
    end

    # Icons
    column(:photo, :header => "") do |member|
      icon(:photo, '', '#', "data-photo" => member.photo(:cropped)) if member.photo
    end
    column(:details, :header => "") do |member|
      icon(:details, '', backend_member_path(member), :title => "Details")
    end
    column(:delete, :header => "") do |member|
      icon(:delete, '', disable_backend_member_path(member),
              :title => "Verwijderen", :method => :post,
              :confirm => "Bent u zeker dat u dit lid wil verwijderen?")
    end
  end
end
