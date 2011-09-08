class Backend::IsicExportsController < Backend::BackendController
  skip_before_filter :verify_club
  before_filter :authenticate
  def authenticate
    authenticate_or_request_with_http_digest('isic') do |username|
      if username == Rails.application.config.isic_user
        # MD5 of username:realm:password
        Digest::MD5.hexdigest([username, 'isic', Rails.application.config.isic_pass].join(':'))
      end
    end
  end

  def index
    @exports = IsicExport.order('created_at DESC')
  end

  def create
    export = IsicExport.create_export
    redirect_to backend_isic_exports_path
  end
end
