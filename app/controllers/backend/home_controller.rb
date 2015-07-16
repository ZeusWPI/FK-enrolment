class Backend::HomeController < Backend::BackendController
  def index
  end

  def settings
    if params[:club]
      @club.attributes = params[:club]
      if @club.save
        flash[:success] = "Instellingen gewijzigd."
      end
    end
  end

  def kassa
    # Always show the filter
    @filtered = true

    report_params = { club_id: @club.id }
    if params[:pay_member_report]
      # This order will guarantee club_id cannot be set from the outside
      report_params = params[:pay_member_report].merge(report_params)
    end

    # Defaults
    report_params[:last_registration] ||= Member.current_academic_year

    @membergrid = PayMemberReport.new(report_params)
    @members = @membergrid.assets.paginate(:page => params[:page], :per_page => 30)
  end
end
