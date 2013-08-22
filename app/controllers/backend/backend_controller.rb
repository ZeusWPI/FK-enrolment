class Backend::BackendController < ApplicationController
  respond_to :html
  layout "backend"

  before_filter :verify_club
  def verify_club
    # Development backdoor
    return @club = Club.find_by_internal_name("Chemica") if Rails.env.development?

    if session[:cas_user].blank?
      redirect_to cas_auth_path(:redirect => request.fullpath)
    else
      if session[:club].blank?
        session[:club] = club_for_ugent_login(session[:cas_user])
      end

      @club = Club.find_by_internal_name(session[:club])
      unless @club
        render '/backend/denied', :status => 403
      end
    end
  end

  # return which club this ugent_login is allowed to manage
  def club_for_ugent_login(ugent_login)
    def digest(*args)
      Digest::SHA256.hexdigest args.join('-')
    end

    # using httparty because it is much easier to read than net/http code
    resp = HTTParty.get('http://fkgent.be/api_zeus.php', :query => {
              :k => digest(ugent_login, Rails.application.config.zeus_api_key),
              :u => ugent_login
           })

    # this will only return the club name if control-hash matches
    if resp.body != 'FAIL'
      hash = JSON[resp.body]
      dig = digest(Rails.application.config.zeus_api_salt, ugent_login, hash['kringname'])
      return hash['kringname'] if hash['controle'] == dig
    end

    nil
  end
end
