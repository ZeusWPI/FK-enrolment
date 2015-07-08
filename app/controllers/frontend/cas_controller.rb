class Frontend::CasController < Frontend::FrontendController
  before_filter :load_club, :only => :auth
  def auth
    save_redirect :post_cas_redirect
    session[:fk_books] = request.referer =~ /fkgent.be\/fkbooks/

    redirect_to cas_verify_path
  end

  before_filter :verify_cas, :only => :verify
  skip_before_filter :verify_authenticity_token, :only => :verify
  def verify
    redirect_to session.delete(:post_cas_redirect) || root_url
  end

  def verify_cas
    unless session['cas'] && session['cas']['user']
      # rack-cas will catch this and redirect to CAS before visiting the method
      render text: "Access Denied", status: :unauthorized
    end
  end

  def logout
    redirect_to logout_path(url: root_url)
  end
end
