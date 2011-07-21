class CasController < ApplicationController
  before_filter RubyCAS::Filter, :only => :auth

  def auth
  end
end
