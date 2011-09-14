class Backend::MembersController < Backend::BackendController
  before_filter :load_member, :except => [:index, :search]
  def load_member
    @member, status = Member.find_member_for_club(params['id'], @club)
    if not @member
      redirect_to backend_members_path, :error => "Ongeldig lid."
    end
  end

  def index
    attributes = {:club_id => @club, :enabled => true}

    report_params = {:club_id => @club.id}
    if params[:member_report]
      report_params = report_params.merge(params[:member_report])
    end
    @membergrid = MemberReport.new(report_params)
    @members = @membergrid.assets.paginate(:page => params[:page], :per_page => 1)

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
      Member.includes(:current_card).where({:enabled => true}).order("created_at DESC")
    end

    # Filters
    filter(:club_id)
    filter(:name)
    filter(:ugent_nr)
    filter(:email)
    filter(:card_number)
    filter(:created_at)

    # Columns
    column(:name, :order => "last_name, first_name" ,:header => "Naam") do |member|
      member.last_name + ", " + member.first_name
    end
    column(:ugent_nr, :header => "UGent-nr.")
    column(:email, :header => "E-mailadres")
    column(:card_number, :header => "FK-nummer")
    column(:created_at, :header => "Geregistreerd") do |member|
      I18n.localize member.created_at, :format => :short
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
