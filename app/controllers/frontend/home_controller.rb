class Frontend::HomeController < Frontend::FrontendController
  def index
    @clubs = Club.where("registration_method != ?", :hidden).order(:full_name).all
  end
end
