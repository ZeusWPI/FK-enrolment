class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :add_warning
  def add_warning
  	flash[:warning] = "De registratie-applicatie is nog niet gelanceerd!
  		Alle registraties zullen bij lancering verwijderd worden."
  end
end
