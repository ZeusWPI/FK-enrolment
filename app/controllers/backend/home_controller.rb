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
    report_params = { club_id: @club.id }
    @filtered = true
    if params[:pay_member_report]
      # This order will guarantee club_id cannot be set from the outside
      report_params = params[:pay_member_report].merge(report_params)
    end
    @membergrid = PayMemberReport.new(report_params)
    @members = @membergrid.assets.paginate(:page => params[:page], :per_page => 30)
  end
end

class PayMemberReport
  include BasicMemberReport

  column(:pay, :header => "") do |member|
    link_to "Betalen", pay_backend_member_path(member)
  end
end
