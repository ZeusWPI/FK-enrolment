class Backend::IsicController < Backend::BackendController

  before_filter :authenticate

  def index
    @exports = IsicExport.all
  end

  def create

  end

  def authenticate
    # http://api.rubyonrails.org/classes/ActionController/HttpAuthentication/Basic.html
    authenticate_or_request_with_http_digest('isic') do |username|
       if username == Rails.application.config.isic_user
         Digest::MD5.hexdigest([username, 'isic', Rails.application.config.isic_pass].join(':'))
       end
    end
  end

end
