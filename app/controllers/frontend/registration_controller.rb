class Frontend::RegistrationController < Frontend::FrontendController
  before_filter :load_club!

  # Load member set in session or create a new one
  before_filter :load_member, :except => :index
  def load_member
    if session[:member_id]
      begin
        @member = Member.find session[:member_id]
      rescue ActiveRecord::RecordNotFound
      end
    elsif action_name == "general"
      @member = Member.new
    end

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

  def index
    # We were not sent here through fk-books, so there definitely
    # shouldn't be a redirect afterwards
    session.delete :fk_books
  end

  def general
    # Check if there exists a member with this student-ID
    if !@member.id && cas_authed?
      student_nr = session[:cas_extra_attributes]["ugentStudentID"]
      old_record = Member.member_for_ugent_nr(student_nr, @club)
      if old_record
        @member = old_record
        session[:member_id] = old_record.id
      end
    end

    # Load extra attributes before assigning them
    @member.build_extra_attributes
    @member.attributes = params[:member]

    load_cas_member_attributes if cas_authed?
    load_eid_member_attributes if eid_authed?

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
    eid_authed?

    # All image uploading and processing is done by the model
    if params[:member] && @member.update_attributes(params[:member])
      redirect_to registration_success_path(@club) if @member.valid_photo?
    end
  end

  def success
    @member.update_attribute(:enabled, true)
    session.delete :member_id

    # Redirect to fk-books
    if session.delete :fk_books
      key = Rails.application.config.fkbooks_key
      signature = Digest::SHA1.hexdigest(key + @member.id.to_s)

      redirect_to Rails.application.config.fkbooks % [@member.id, signature]
    end
  end

  private

  def cas_authed?
    @cas_authed = !session[:cas_user].blank?
  end

  def load_cas_member_attributes
    attributes = session[:cas_extra_attributes]
    @member.first_name = attributes["givenname"]
    @member.last_name = attributes["surname"]
    @member.ugent_nr = attributes["ugentStudentID"]
  end

  def eid_authed?
    @eid_authed = !session[:eid].blank?
  end

  def load_eid_member_attributes
    attributes = session[:eid]
    key_prefix = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/"

    @member.first_name = attributes[key_prefix + "givenname"]
    @member.last_name = attributes[key_prefix + "surname"]
    sex = attributes[key_prefix + "gender"]
    @member.sex = {'1' => 'm', '2' => 'f'}[sex] || @member.sex
    @member.date_of_birth = Date.parse attributes[key_prefix + "dateofbirth"]
    @member.home_address = attributes[key_prefix + "streetaddress"] + "\n" +
                           attributes[key_prefix + "postalcode"] + " " +
                           attributes[key_prefix + "locality"]
  end
end
