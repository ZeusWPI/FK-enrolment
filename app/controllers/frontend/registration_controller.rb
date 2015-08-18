class Frontend::RegistrationController < Frontend::FrontendController
  before_filter :load_club!

  # Load member set in session or create a new one
  before_filter :load_member, :only => [:isic, :photo, :success]
  before_filter :create_member, :only => [:general]

  def load_member
    @member = Member.find_by id: session[:member_id] if session[:member_id]

    unless @member
      # Return to start to create a new member
      session.delete :member_id
      redirect_to registration_root_path(@club)
    else
      # Always set the member to the club from the current club-param
      # so the record ends up in the right place, even when the url changes
      @member.club = @club
    end
  end

  def create_member
    @member = Member.new
    @member.club = @club
    @member.build_extra_attributes
    @member.attributes = params[:member] if params[:member]
    load_cas_member_attributes if cas_authed?
    load_eid_member_attributes if eid_authed?
  end

  def index
    # We were not sent here through fk-books, so there definitely
    # shouldn't be a redirect afterwards
    session.delete :fk_books
  end

  def pick_card_type
    # Do not pick a card type when you don't have a choice.
    if [@club.uses_fk, @club.uses_isic].count(true) == 1
      redirect_to registration_general_path(@club)
    else
      render :cardtype
    end
  end

  def general
    if @member.save
      session[:member_id] = @member.id
      if @member.uses_isic?
        redirect_to registration_isic_path(@club)
      else
        redirect_to registration_success_path(@club)
      end
    end
  end

  def isic
    @member.isic_mail_card = true if @club.isic_mail_option == Club::ISIC_MAIL_CARD_FORCED
    if params[:member] && @member.update(params[:member])
      redirect_to registration_photo_path(@club)
    end
  end

  def photo
    # All image uploading and processing is done by the model
    if params[:member] && @member.update(params[:member])
      @member.crop_photo
      redirect_to registration_success_path(@club) if @member.valid_photo?
    end
  end

  def success
    @member.update_attribute(:enabled, true)
    session.delete :member_id

    # Redirect to fk-books
    if session.delete :fk_books
      key = Rails.application.secrets.fkbooks_key
      signature = Digest::SHA1.hexdigest(key + @member.id.to_s)

      redirect_to Rails.application.secrets.fkbooks % [@member.id, signature]
    end
  end

  helper_method :cas_authed?
  def cas_authed?
    session[:cas] && session[:cas]['user']
  end

  helper_method :eid_authed?
  def eid_authed?
    !session[:eid].blank?
  end

  private

  def load_cas_member_attributes
    attributes = session[:cas]["extra_attributes"]
    @member.first_name = attributes["givenname"]
    @member.last_name = attributes["surname"]
    @member.ugent_nr = attributes["ugentStudentID"]
  end

  def load_eid_member_attributes
    attributes = session[:eid]
    key_prefix = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/"

    @member.first_name = attributes[key_prefix + "givenname"]
    @member.last_name = attributes[key_prefix + "surname"]
    @member.date_of_birth = Date.parse attributes[key_prefix + "dateofbirth"]
    @member.home_street = attributes[key_prefix + "streetaddress"]
    @member.home_postal_code = attributes[key_prefix + "postalcode"]
    @member.home_city = attributes[key_prefix + "locality"]

    sex = attributes[key_prefix + "gender"]
    @member.sex = {'1' => 'm', '2' => 'f'}[sex] || @member.sex
  end
end
