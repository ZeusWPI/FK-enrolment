class Backend::HomeController < Backend::BackendController
  def index
  end

  def settings
    @club.update_attributes!(params[:club]) if params[:club]
  end

  def kassa

  end

end
