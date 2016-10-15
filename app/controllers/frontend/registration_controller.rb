class Frontend::RegistrationController < Frontend::FrontendController
  include Wicked::Wizard
  # Member states are steps, except for 'initial'
  steps :authenticate, *Member::States.drop(1)

  before_filter :load_club!
  before_filter :load_member, :only => [:show, :update]
  before_filter :verify_club

  def load_member
    @member = Member.unscoped.find(session[:member_id]) if session[:member_id]
    if !@member
      redirect_to registration_index_path
    else
      send_to_correct_step
      @member.build_extra_attributes
    end
  end

  def index
    create_member
    super
  end

  def show
    set_state
    self.send step if self.respond_to? step
    render_wizard
  end

  def update
    set_state
    @member.assign_attributes params[:member] if params[:member]
    self.send step if self.respond_to? step
    render_wizard @member unless performed?
  end

  def card_type
    skip_step if @club.allowed_card_types.count == 1
  end

  def info
    load_cas_member_attributes if cas_authed?
    load_eid_member_attributes if eid_authed?
  end

  def questions
    skip_step if @member.extra_attributes.empty?
  end

  def isic
    skip_step unless @member.uses_isic?
    @member.isic_mail_card = true if @club.isic_mail_option == Club::ISIC_MAIL_CARD_FORCED
  end

  def photo
    skip_step unless @member.uses_isic? || (@member.uses_citylife? && ! @member.club.skip_photo_step)
    if params[:member]
      @member.save # Trigger paperclip callbacks
      # All image uploading and processing is done by the model
      @member.crop_photo
      render_wizard unless @member.valid_photo?
    end
  end

  def complete
    # Finish registration
    @member.enabled = true
    @member.save
    skip_step
  end

  def finish_wizard_path
    success_path
  end

  def success
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

  def create_member
    @member = Member.new
    @member.state = 'initial'
    @member.club = @club
    @member.save!
    session[:member_id] = @member.id
  end

  def set_state step=self.step
    if Member::States.include? step
      step_index = Member::States.index(step)
      member_index = Member::States.index(@member.state)
      @member.state = step if member_index < step_index
    end
  end

  # If the steps list is changed, this method will probably
  # no longer be valid.
  def send_to_correct_step
    if Member::States.include? step
      original_state = @member.state
      set_state previous_step
      if !@member.valid?
        member_step = wizard_steps.index(original_state) || 0
        jump_to wizard_steps[member_step.next]
      end
    end
  end

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

  def verify_club
    redirect_to root_path, alert: 'This club doesn\'t use website registration' unless @club.registration_method == 'website'
  end
end
