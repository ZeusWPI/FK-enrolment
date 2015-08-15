class Frontend::FrontendController < ApplicationController
  layout "frontend"

  def load_club
    if params[:club]
      @club = Club.where('LOWER(internal_name) = ?', params[:club])
                  .using([:website, :hidden]).first
    end
  end

  def load_club!
    raise ActionController::RoutingError.new('Unknown club') unless load_club
  end

  def save_redirect(identifier)
    if params[:redirect]
      session[identifier] = params[:redirect]
    elsif @club
      session[identifier] = registration_card_type_path(@club)
    end
  end
end
