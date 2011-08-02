class Api::ApiController < ApplicationController
  before_filter :verify_key
  respond_to :json

  def verify_key
    @club = Club.find_by_api_key(params[:key])
    unless @club && @club.api_key?
      respond_with({:error => "Invalid API-key"}, :status => :forbidden)
    end
  end

  def test
    respond_with(status: "ok", club: @club.name)
  end

  def club
    respond_with(:api, @club)
  end
end
