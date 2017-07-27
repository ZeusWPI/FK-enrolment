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
    resp = HTTParty.get("#{ Rails.application.secrets.fk_auth_url }/#{ ugent_login }/FKEnrolment",
                        headers: {
                            'X-Authorization': Rails.application.secrets.fk_auth_key,
                            Accept: 'application/json'
                        })

    # this will only return the club names if control-hash matches
    if resp.success?
      hash = JSON[resp.body]
      clubs = hash['clubs'].map do |club| club['internal_name'] end
      timestamp = hash['timestamp']

      # Timestamp can't differ by more than 5 minutes
      return [] unless (Time.now - DateTime.parse(timestamp)).abs < 5.minutes
      dig = digest(Rails.application.secrets.fk_auth_salt, ugent_login, timestamp, clubs)

      return clubs if hash['sign'] == dig
    end
    []
  end
end
