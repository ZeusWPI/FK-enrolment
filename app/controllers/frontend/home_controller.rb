class Frontend::HomeController < Frontend::FrontendController
  def index
    @clubs = Club.visible.all
  end
end
