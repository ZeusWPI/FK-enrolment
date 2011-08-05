class Frontend::HomeController < Frontend::FrontendController
  def index
    @clubs = Club.order(:full_name).all
  end
end
