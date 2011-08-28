class Frontend::RegistrationController < Frontend::FrontendController
  before_filter :load_club
  def load_club
    @club = Club.using(:website).where('LOWER(internal_name) = ?', params[:club]).first
    redirect_to root_path if not @club
  end

  # Load member set in session or create a new one
  before_filter :load_member, :except => [:index]
  def load_member
    if session[:member_id]
      begin
        @member = Member.find(session[:member_id])
      rescue ActiveRecord::RecordNotFound
      end
    elsif action_name == "general"
      @member = Member.new
    end

    unless @member
      # Return to start to create a new member
      session[:member_id] = nil
      redirect_to registration_root_path(@club)
    else
      # Always set the member to the club from the current club-param
      # so the record ends up in the right place, even when the url changes
      @member.club = @club if @member
    end
  end

  def index
    # We were not sent here through fk-books, so there definitely
    # shouldn't be a redirect afterwards
    session[:fk_books] = nil
  end

  def general
    # Load extra attributes before assigning them
    @member.build_extra_attributes
    @member.attributes = params[:member]

    # Override properties if they're already set through CAS
    @cas_authed = !session[:cas_user].blank?
    if @cas_authed
      attributes = session[:cas_extra_attributes]
      @member.first_name = attributes["givenname"]
      @member.last_name = attributes["surname"]
      @member.ugent_nr = attributes["ugentStudentID"]
    end

    if params[:member] && @member.save
      session[:member_id] = @member.id

      # Redirect to next_step based on club preferences
      if @club.uses_isic
        redirect_to registration_isic_path(@club)
      else
        redirect_to registration_success_path(@club)
      end
    end
  end

  def isic
    if params[:member] && @member.update_attributes(params[:member])
      redirect_to registration_photo_path(@club)
    end
  end

  def photo
    # All image uploading and processing is done by the model
    if params[:member] && @member.update_attributes(params[:member])
      redirect_to registration_success_path(@club) if @member.valid_photo?
    end
  end

  def success
    @member.update_attribute(:enabled, true)
    session[:member_id] = nil

    # Redirect to fk-books
    if session[:fk_books]
      key = Rails.application.config.fkbooks_key
      signature = Digest::SHA1.hexdigest(key + @member.id.to_s)

      redirect_to Rails.application.config.fkbooks % [@member.id, signature]
      session[:fk_books] = nil
    end
  end
end
