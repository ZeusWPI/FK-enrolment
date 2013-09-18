require 'member_report'
require 'excel_export'

class Backend::MembersController < Backend::BackendController
  before_filter :load_member, :except => [:index]
  def load_member
    @member, status = Member.find_member_for_club(params['id'], @club)
    unless @member
      redirect_to backend_members_path, :alert => "Ongeldig lid."
    end
  end

  def index
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

    @membergrid = MemberReport.new(report_params)
    @members = @membergrid.assets

    respond_to do |format|
      format.html {
        @members = @members.paginate(:page => params[:page], :per_page => 30)

        attributes = {:club_id => @club, :enabled => true}
        @registered_members = Member.active_registrations.where(attributes).count
        @card_members = Member.active_registrations.where(attributes).joins(:current_card).count
      }
      format.xls {
        name = "Export %s %s.xls" % [@club.internal_name, Time.now.strftime('%F %T')]
        @members = @members.includes({:club => :extra_attributes}, :extra_attributes)
        send_data ExcelExport.create(@members), :filename => name, :type => :xls
      }
    end
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
    @card = @member.current_card
    unless @card
      @card = Card.new
      @card.member = @member
      @card.determine_isic_status if @member.club.uses_isic
    end

    if params[:card] || params[:commit]
      @card.attributes = params[:card]
      @card.status = 'paid'

      if @card.save
        # Submit (asynchronously) info to ISIC
        # @card.delay.export_to_isic
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
end
