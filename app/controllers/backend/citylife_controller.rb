class Backend::CitylifeController < Backend::MembersController
  before_action :load_club, except: [ :index ]
  skip_before_filter :verify_cas, :verify_club

  respond_to :html, :js

  def index
    @clubs = Club.where uses_citylife: true
  end

  private
  def load_club
    @club = Club.with_internal_name(params[:club]).first
    raise "This club doesn't use Citylife cards" unless @club.uses_citylife?
  end
end