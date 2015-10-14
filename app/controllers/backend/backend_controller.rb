class Backend::BackendController < ApplicationController
  respond_to :html
  layout "backend"
  helper_method :clubnames_for_current_user

  before_filter :verify_cas, :verify_club

  def verify_cas
    if session[:cas].blank? && !Rails.env.development?
      redirect_to cas_auth_path(:redirect => request.fullpath)
    end
  end

  def verify_club
    @club = Club.with_internal_name(clubname_for_current_user).first
    unless @club
      render '/backend/denied', :status => 403
    end
  end

  # return which club this ugent_login is allowed to manage
  # Provides a default club for backwards compatibility
  def clubname_for_current_user
    if session[:club].blank?
      session[:club] = clubnames_for_current_user.first
    end
    session[:club]
  end

  def clubnames_for_current_user
    if session['clubnames'].blank?
      session['clubnames'] = request_clubnames
    end
    session['clubnames']
  end

  private
  def request_clubnames
    # Development backdoor
    return Club.pluck(:internal_name) if Rails.env.development?

    ugent_login = session[:cas]['user']
    def digest(*args)
      Digest::SHA256.hexdigest args.join('-')
    end

    # using httparty because it is much easier to read than net/http code
    resp = HTTParty.get(Rails.application.secrets.fk_auth_url, :query => {
             :k => digest(ugent_login, Rails.application.secrets.fk_auth_key),
             :u => ugent_login
         })

    # this will only return the club names if control-hash matches
    if resp.body != 'FAIL'
      hash = JSON[resp.body]
      dig = digest(Rails.application.secrets.fk_auth_salt, ugent_login, hash['clubnames'])
      return hash['clubnames'] if hash['control'] == dig
    end
    []
  end
end
