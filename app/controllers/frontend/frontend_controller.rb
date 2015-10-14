class Frontend::FrontendController < ApplicationController
  layout "frontend"

  def load_club
    if params[:club]
      @club = Club.with_internal_name(params[:club]).first
    end
  end

  def load_club!
    raise ActionController::RoutingError.new('Unknown club') unless load_club
  end

  def save_redirect(identifier)
    if params[:redirect]
      session[identifier] = params[:redirect]
    elsif @club
      # TODO: update redirect
      session[identifier] = ""
    end
  end
end
