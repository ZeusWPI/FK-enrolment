class Frontend::EidController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    request = Onelogin::Saml::Authrequest.new
    redirect_to request.create(saml_settings)
  end

  def receive
    response = Onelogin::Saml::Response.new(params[:SAMLResponse])
    response.settings = saml_settings

    render :text => response.attributes.to_json
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
