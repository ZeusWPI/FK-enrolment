class Backend::HomeController < Backend::BackendController
  def index
    @club.update_attributes!(params[:club]) if params[:club]
  end
end
