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
end
