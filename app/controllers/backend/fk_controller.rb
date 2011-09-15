class Backend::FkController < Backend::BackendController

  skip_before_filter :verify_club
  before_filter :verify_fk
  def verify_fk
    # Development backdoor
    return session[:club] = "FK" if request.local?

    if session[:cas_user].blank?
      redirect_to cas_auth_path(:redirect => request.fullpath)
    else
      if session[:club].blank?
        session[:club] = club_for_ugent_login(session[:cas_user])
      end

      render '/backend/denied', :status => 403 unless session[:club] == "FK"
    end
  end

  def index
    @clubs = Club.order(:name)
    @data = {
      :count => Member,
      :paid => Member.joins(:current_card).where(:cards => {:status => 'paid'}),
      :isic => Member.joins(:current_card).where(:cards => {:isic_status => 'requested'})
    }
    @data.each { |key, value| @data[key] = value.where(:enabled => true).group(:club).count }
  end
end
