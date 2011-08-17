class Backend::BackendController < ApplicationController
  layout "backend"

  before_filter :verify_auth
  def verify_auth
    # TODO: real auth
    @club = Club.find_by_internal_name("Chemica")
    unless @club
      respond_with({:error => "Invalid API-key"}, :status => :forbidden, :location => nil)
    end
  end


  # return true if the ugent_login is allowed to manage the club
  def check_auth(ugent_login, club_name)
    # using httparty because it is much easier to read than net/http code
    resp = HTTParty.get('http.fkgent.be/api_zeus.php', 
                  :query => {
                    :k => Rails::Application.config.zeus_api_key, 
                    :u => ugent_login
                  }
                )

    # keep checking if something is wrong fall through and return false
    if resp.body != 'FAIL'
      hash = JSON[resp.body]
      if hash['kringname'] == club_name
        dig = Digest::SHA256.hexdigest Rails::Application.config.zeus_api_salt + '-' + ugent_login + club_name
        return hash['controle'] == dig
      end
    end
    false
  end

end
