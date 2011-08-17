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


  # return which club this ugent_login is allowed to manage 
  def club_for_ugent_login(ugent_login)
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
      dig = Digest::SHA256.hexdigest Rails::Application.config.zeus_api_salt + '-' + ugent_login + hash['kringname']
      return hash['kringname'] if hash['controle'] == dig
    end
    false
  end

end
