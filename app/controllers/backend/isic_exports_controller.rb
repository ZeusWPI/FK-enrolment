class Backend::IsicExportsController < Backend::BackendController
  skip_before_filter :verify_club
  before_filter :authenticate
  def authenticate
    realm = 'ISIC authenticatie'
    authenticate_or_request_with_http_digest(realm) do |username|
      if username == Rails.application.config.isic_user
        # MD5 of username:realm:password
        Digest::MD5.hexdigest([username, realm, Rails.application.config.isic_pass].join(':'))
      end
    end
  end

  def index
    @exports = IsicExport.order('created_at DESC')
    @unexported = Member.find_all_for_isic_export
  end

  def create
    IsicExport.send_later(:create_export)
    redirect_to backend_isic_exports_path, :notice => 'De export wordt in de achtergrond aangemaakt'
  end

  def data
    export = IsicExport.find(params[:id])
    send_file(export.data.path,
      :filename => export.data.original_filename,
      :type => :xls
    )
  end

  def photos
    export = IsicExport.find(params[:id])
    send_file(export.photos.path,
      :filename => export.photos.original_filename,
      :type => :zip
    )
  end

end
