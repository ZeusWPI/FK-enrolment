class Frontend::CasController < Frontend::FrontendController
  before_filter :load_club, :only => :auth
  def auth
    save_redirect :post_cas_redirect
    session[:fk_books] = request.referer =~ /fkgent.be\/fkbooks/

    redirect_to cas_verify_path
  end

  def verify
    render text: "Access Denied", status: :unauthorized
  end

end
