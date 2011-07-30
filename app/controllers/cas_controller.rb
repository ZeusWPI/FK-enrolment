class CasController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :auth
  before_filter RubyCAS::Filter, :only => :auth

  def auth
    # Don't save the ticket, it contains a singleton somewhere that can't be marshalled
    session[:cas_last_valid_ticket] = nil
  end
end
