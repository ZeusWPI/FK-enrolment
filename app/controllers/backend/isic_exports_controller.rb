class Backend::IsicExportsController < Backend::BackendController
  skip_before_filter :verify_club
  before_filter :authenticate

  def authenticate
    realm = 'ISIC authenticatie'
    authenticate_or_request_with_http_digest(realm) do |username|
      if username == Rails.application.config.isic_user
        # MD5 of username:realm:password
        Digest::MD5.hexdigest([username, realm, Rails.application.config.isic_pass].join(':'))
      end
    end
  end

  def import
    if params[:input]
      require 'csv'
      @result = ""
      CSV.parse(params[:input], :col_sep => ';').each do |row|
        fk_number, isic_number, email = row
        card = Card.where(:number => fk_number, :academic_year => 2011, :enabled => 1)

        if card.count == 0
          @result << "<li>Card #{fk_number} not found!</li>"
        elsif card.count > 1
          @result << "<li>Multiple cards found for #{fk_number}</li>"
        elsif card.first.member.email != email
          @result << "<li>Email mismatch for #{fk_number}, expecting #{card.first.member.email}"
        else
          card.first.update_attribute :isic_number, isic_number
        end
      end
    end
  end

  def index
    @unexported = Member.find_all_for_isic_export(false, "new")
    @clubs = Club.where(:uses_isic => true).all

    # Only show exports created after July 1st
    cutoff = Time.new(Member.current_academic_year, 7, 1)
    @exports = IsicExport.where('created_at >= ?', cutoff).order('created_at DESC')
  end

  def create
    members = Member.find_all_for_isic_export(params[:club], params[:type])
    if members.count > 0
      export = IsicExport.new
      export.members = members.map(&:id)
      export.save
      export.send_later(:generate)
      redirect_to backend_isic_exports_path, :notice => ('De export wordt gegenereerd. ' \
        'Gelieve binnen enkele minuten deze pagina opnieuw te laden.')
    else
      redirect_to backend_isic_exports_path, :notice => ('Er werden geen kaarten gevonden ' \
        'die aan deze voorwaarden voldoen.')
    end
  end

  def data
    export = IsicExport.find params[:id]
    send_file(export.data.path,
      :filename => export.data.original_filename,
      :type => :xls
    )
  end

  def photos
    export = IsicExport.find params[:id]
    send_file(export.photos.path,
      :filename => export.photos.original_filename,
      :type => :zip
    )
  end
end
