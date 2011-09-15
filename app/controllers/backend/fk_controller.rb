class Backend::FkController < Backend::BackendController

  skip_before_filter :verify_club
  before_filter :verify_fk

  def verify_fk
    if request.local?
      session[:club] = "FK" and return
    end

    if session[:cas_user].blank?
      redirect_to cas_auth_path(:redirect => request.fullpath)
    else
      if session[:club].blank?
        session[:club] = club_for_ugent_login(session[:cas_user])
      end
      if session[:club] != "FK"
        render '/backend/denied', :status => 403
      end
    end
  end

  def index
    @count = Member.includes(:club).where(:enabled => true).group(:club).count
    @paid = Member.includes(:club).joins(:current_card).where(:enabled => true).where(:cards => {:status => 'paid'}).group(:club).count
  end
end
