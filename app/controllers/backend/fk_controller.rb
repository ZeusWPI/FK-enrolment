class Backend::FkController < Backend::BackendController

  skip_before_filter :verify_club
  before_filter :verify_fk

  def index
    @count = Member.includes(:club).where(:enabled => true).group(:club).count
  end
end
