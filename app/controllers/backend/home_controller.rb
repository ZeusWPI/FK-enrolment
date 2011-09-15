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
    report_params = {:club_id => @club.id}
    @filtered = false
    if params[:member_report]
      # This will check if members are actually filtered
      params[:member_report].each do |key, value|
        next if key == "order" ||
                key == "descending" ||
                key == "club_id" ||
                (key == "card_holders_only" && value == "false")
        if value != ""
          @filtered = true
          break
        end
      end
      # This order will guarantee club_id cannot be set from the outside
      report_params = params[:member_report].merge(report_params)
    end
    @membergrid = PayMemberReport.new(report_params)
    @members = @membergrid.assets.paginate(:page => params[:page], :per_page => 1)
  end
end
