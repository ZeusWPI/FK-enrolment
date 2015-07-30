class Api::ApiController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json

  before_filter :verify_key
  def verify_key
    @club = Club.find_by_api_key(params[:key])
    unless @club && @club.api_key?
      respond_with({:error => "Invalid API-key"}, :status => :forbidden, :location => nil)
    end
  end

  # verify gandalf API key
  def verify_gandalf_key
    unless params[:key] == Rails.application.secrets.fk_gandalf_key
      respond_with({:error => "Invalid Gandalf-key"}, :status => :forbidden, :location => nil)
    end
  end

  def unwrap_params(name)
    # why is member_id in this list?
    params[name] || params.except(:controller, :action, :format, :key, :member_id)
  end

  def test
    respond_with(status: "ok", club: @club.name)
  end

  def club
    respond_with(:api, @club)
  end
end
