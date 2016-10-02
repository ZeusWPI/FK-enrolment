class Backend::MembersController < Backend::BackendController
  before_filter :load_member, :except => [:index]
  skip_before_filter :load_member, only: [:export_status, :export_xls, :generate_export]

  respond_to :html, :js

  def load_member
    @member, _ = Member.find_member_for_club(params['id'], @club)
    unless @member
      redirect_to backend_members_path, :alert => "Ongeldig lid."
    end
  end

  def index
    @report_params = filter_params

    @membergrid = MemberReport.new(@report_params)
    @members = @membergrid.assets

    @members = @members.paginate(:page => params[:page], :per_page => 30)

    attributes = {:club_id => @club, :enabled => true}
    @registered_members = Member.active_registrations.where(attributes).count
    @card_members = Member.active_registrations.where(attributes).joins(:current_card).count
  end

  def edit
  end

  def update
    if @member.update(member_params)
      redirect_to backend_member_path(@member), notice: 'Successfully updated member.'
    end
  end

  def export_status
    if @club.export_status == 'done'
      render partial: 'export'
    else
      redirect_to :back, status: :not_found
    end
  end

  def export_xls
    name = "Export %s %s.xls" % [@club.internal_name, Time.now.strftime('%F %T')]
    send_file @club.export.path, :filename => name, :type => :xls
  end

  def generate_export
    @report_params = filter_params

    # Use (abuse?) the memberreport for filtering of the parameters
    membergrid = MemberReport.new(@report_params)
    members = membergrid.assets
    ids = members.pluck(:id)

    # (Legacy) In the past, 1 member could have multiple cards
    # for multiple years. We pass the academic year to select
    # the correct cards in the ExcelExport. filter_params makes
    # this default to the last academic year.
    @club.generate_xls(ids, @report_params[:academic_year])
  end

  def disable
    @member.disable
    redirect_to backend_members_path, :success => "#{@member.name} werd verwijderd."
  end

  def show
    # Load extra attributes with specs
    @extra_attributes = @member.extra_attributes.includes(:spec).all
  end

  def pay
    @card = @member.current_card || Card.build_for(@member)

    if params[:card] || params[:commit]
      @card.attributes = params[:card] if params[:card]
      @card.status = 'paid'

      if @card.save
        # Submit (asynchronously) info to ISIC
        @card.export
      else
        # Reset card number after unsuccesful save
        @card.number = nil
        @card.status = 'unpaid'
      end
    end
  end

  def photo
    @member.update_attributes(params[:member]) if params[:member]
  end

  private

  def filter_params
    report_params = { club_id: @club.id }
    @filtered = false
    if params[:member_report]
      # This will check if members are actually filtered
      @filtered = params[:member_report].any? do |key, value|
        next false if %w(order descending club_id).include?(key)
        key == 'card_holders_only' ? value == '1' : !value.blank?
      end

      # This order will guarantee club_id cannot be set from the outside
      report_params = params[:member_report].merge(report_params)
    end

    # Defaults
    report_params[:last_registration] ||= Member.current_academic_year

    report_params
  end

  def member_params
    params.require(:member).permit(:first_name, :last_name, :email, :ugent_nr, :sex, :phone, :date_of_birth,
                                  :home_street, :home_postal_code, :home_city)
  end
end
