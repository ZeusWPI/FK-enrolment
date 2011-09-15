class Backend::MembersController < Backend::BackendController
  before_filter :load_member, :except => [:index]
  def load_member
    @member, status = Member.find_member_for_club(params['id'], @club)
    if not @member
      redirect_to backend_members_path, :alert => "Ongeldig lid."
    end
  end

  def index
    report_params = {:club_id => @club.id}
    @filtered = false
    if params[:member_report]
      # This will check if members are actually filtered
      @filtered = params[:member_report].any? do |key, value|
        return false if %w(order descending club_id).include?(key)
        key == "card_holders_only" ? value == '1' : !value.blank?
      end

      # This order will guarantee club_id cannot be set from the outside
      report_params = params[:member_report].merge(report_params)
    end
    @membergrid = MemberReport.new(report_params)
    @members = @membergrid.assets

    respond_to do |format|
      format.html {
        @members = @members.paginate(:page => params[:page], :per_page => 30)

        attributes = {:club_id => @club, :enabled => true}
        @registered_members = Member.where(attributes).count
        @card_members = Member.where(attributes).joins(:current_card).count
        render
      }
      format.xls {
        name = "Export %s %s.xls" % [@club.internal_name, Time.now.strftime('%F %T')]
        @members = @members.includes({:club => :extra_attributes}, :extra_attributes)
        send_data Member.export(@members), :filename => name, :type => :xls
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
end
