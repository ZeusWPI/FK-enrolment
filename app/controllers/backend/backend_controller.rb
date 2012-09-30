class Backend::BackendController < ApplicationController
  respond_to :html
  layout "backend"

  before_filter :verify_club
  def verify_club
    # Development backdoor
    return @club = Club.find_by_internal_name("Chemica") if Rails.env.development?

    if session[:cas_user].blank?
      redirect_to cas_auth_path(:redirect => request.fullpath)
    else
      if session[:club].blank?
        session[:club] = club_for_ugent_login(session[:cas_user])
      end

      @club = Club.find_by_internal_name(session[:club])
      unless @club
        render '/backend/denied', :status => 403
      end
    end
  end

  # return which club this ugent_login is allowed to manage
  def club_for_ugent_login(ugent_login)
    def digest(*args)
      Digest::SHA256.hexdigest args.join('-')
    end

    # using httparty because it is much easier to read than net/http code
    resp = HTTParty.get('http://fkgent.be/api_zeus.php', :query => {
              :k => digest(ugent_login, Rails.application.config.zeus_api_key),
              :u => ugent_login
           })

    # this will only return the club name if control-hash matches
    if resp.body != 'FAIL'
      hash = JSON[resp.body]
      dig = digest(Rails.application.config.zeus_api_salt, ugent_login, hash['kringname'])
      return hash['kringname'] if hash['controle'] == dig
    end

    nil
  end
end

module BasicMemberReport
  def self.included(klass)
    klass.instance_eval do
      include Datagrid
      extend ActionView::Helpers::UrlHelper
      extend ActionView::Helpers::TagHelper
      extend ApplicationHelper
      class << self
        include Rails.application.routes.url_helpers
      end

      scope do
        Member.includes(:current_card)
              .active_registrations.where({:enabled => true})
              .order("members.created_at DESC")
      end

      # Filters
      filter(:club_id, :integer)
      filter(:first_name) do |value|
        self.where(["LOWER(members.first_name) LIKE ?", "%#{value.downcase}%"])
      end
      filter(:last_name) do |value|
        self.where(["LOWER(members.last_name) LIKE ?", "%#{value.downcase}%"])
      end
      filter(:ugent_nr)
      filter(:email) do |value|
        self.where(["LOWER(members.email) LIKE ?", "%#{value.downcase}%"])
      end
      filter(:card_number) do |value|
        self.where(["cards.number = ?", value])
      end
      filter(:card_holders_only, :boolean) do |value|
        self.where(["cards.number IS NOT NULL"])
      end

      # Columns
      column(:name, :order => "last_name, first_name" ,:header => "Naam") do |member|
        member.last_name + ", " + member.first_name
      end
      column(:ugent_nr, :header => "UGent-nr.")
      column(:email, :header => "E-mailadres")
      column(:card_number, :header => "FK-nummer")
      column(:created_at, :order => "members.created_at", :header => "Geregistreerd") do |member|
        I18n.localize member.created_at, :format => :short
      end
      column(:photo, :header => "") do |member|
        if member.photo?
          icon(:photo, '', photo_backend_member_path(member),
            "data-photo" => member.photo(:cropped))
        else
          icon(:nophoto, '', photo_backend_member_path(member))
        end
      end
    end
  end
end
