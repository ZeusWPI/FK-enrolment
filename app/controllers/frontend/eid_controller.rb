class Frontend::EidController < Frontend::FrontendController
  before_filter :load_club, :only => :auth
  def auth
    save_redirect :post_eid_redirect

    request = Onelogin::Saml::Authrequest.new
    redirect_to request.create(saml_settings)
  end

  skip_before_filter :verify_authenticity_token, :only => :receive
  def receive
    result = Onelogin::Saml::Response.new(params[:SAMLResponse])
    session[:eid] = result.attributes

    redirect_to session.delete(:post_eid_redirect) || root_url
  end

  def logout
    session.delete :eid
    redirect_to root_url
  end

  private

  def saml_settings
    Onelogin::Saml::Settings.new.tap do |s|
      s.idp_sso_target_url             = "https://www.e-contract.be/eid-idp/protocol/saml2/post/ident?language=nl"
      s.idp_cert_fingerprint           = "6ce7a376a1394a1be3585536685d7fdc7da19fb6"
      s.assertion_consumer_service_url = eid_receive_url
      s.issuer                         = request.host_with_port
    end
  end
end
