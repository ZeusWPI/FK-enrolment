class Backend::BackendController < ApplicationController
  respond_to :html
  layout "backend"

  before_filter :verify_club
  def verify_club
    # Development backdoor
    return @club = Club.find_by_internal_name("Chemica") if Rails.env.development?

    if session[:cas].blank?
      redirect_to cas_auth_path(:redirect => request.fullpath)
    else
      @club = Club.find_by_internal_name(clubname_for_current_user)
      unless @club
        render '/backend/denied', :status => 403
      end
    end
  end

  # return which club this ugent_login is allowed to manage
  # Provides a default club for backwards compatibility
  def clubname_for_current_user
    if session[:club].blank?
      clubs = clubnames_for_current_user
      session[:club] = clubs[0] if clubs.any? else nil
    end
    session[:club]
  end

  def clubnames_for_current_user
    return %w(Chemica Wina) if Rails.env.development?
    ugent_login = session[:cas]['user']
    Rails.cache.fetch("clubnames/#{ugent_login}", :expires_in => 12.hours) do
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
        dig = digest(Rails.application.secrets.fk_auth_salt, ugent_login, hash['kringen'])
        return hash['kringen'] if hash['controle'] == dig
      end

      []
    end
  end
end
