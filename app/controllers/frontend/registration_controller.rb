class Frontend::RegistrationController < Frontend::FrontendController
  include Wicked::Wizard
  steps :authenticate, :isic, :info, :questions, :isic_options, :photo, :save

  before_filter :load_club!, :except => :scriptcamhack
  before_filter :load_member, :except => :scriptcamhack

  def load_member
    @member = PartialMember.new
    @member.wizard = self
    @member.club = @club
    @member.build_extra_attributes
    @member.attributes = session[:member] if session[:member]
  end

  def index
    session.delete :member
    super
  end

  def show
    self.send step if self.respond_to? step
    render_wizard
  end

  def update
    @member.assign_attributes params[:member] if params[:member]
    self.send step if self.respond_to? step
    render_wizard @member unless performed?
  end

  def isic
    skip_step if @club.allowed_card_types.count == 1
  end

  def info
    load_cas_member_attributes if cas_authed?
    load_eid_member_attributes if eid_authed?
  end

  def questions
    skip_step if @member.extra_attributes.empty?
  end

  def isic_options
    skip_step unless @member.uses_isic?
    @member.isic_mail_card = true if @club.isic_mail_option == Club::ISIC_MAIL_CARD_FORCED
  end

  def photo
    skip_step unless @member.uses_isic?
    binding.pry
    if params[:member]
      # All image uploading and processing is done by the model
      @member.crop_photo
      render_wizard unless @member.valid_photo?
    end
  end

  def save
    # finish registration
    session.delete :member
    @member.enabled = true
    @member.build.save!
    skip_step
  end

  def finish_wizard_path
    success_path
  end

  def success
    # Redirect to fk-books
    if session.delete :fk_books
      key = Rails.application.secrets.fkbooks_key
      signature = Digest::SHA1.hexdigest(key + @member.id.to_s)

      redirect_to Rails.application.secrets.fkbooks % [@member.id, signature]
    end
  end

  class PartialMember < Member
    attr_accessor :wizard
    delegate :session, :step, :wizard_steps, to: :wizard

    VALIDATIONS = {
      info: [:first_name, :last_name, :email, :ugent_nr,
             :sex, :date_of_birth, :home_street, :home_postal_code,
             :home_city],
      photo: [:photo],
      questions: [:'extra_attributes.value']
    }

    # HACKS HACKS HACKS
    def self.model_name
      self.superclass.model_name
    end

    def unfinished_steps
      return [] if !step
      index = wizard_steps.index step
      wizard_steps[index.succ..wizard_steps.length]
    end

    def valid?
      todo = unfinished_steps.map {|step| VALIDATIONS[step]}.flatten
      super # Call original implementation
      todo.each { |field| self.errors.delete field }
      self.errors.empty?
    end

    # TODO: Can this be generalized?
    def extended_attributes
      self.attributes.merge(
        "extra_attributes_attributes" => extra_attributes_attributes
      )
    end

    def save
      # Save to session
      session[:member] = self.extended_attributes if valid?
    end

    def build
      # Club is required for building extra attributes
      member = self.class.superclass.new
      member.club = self.club
      member.build_extra_attributes
      member.assign_attributes self.extended_attributes,
        without_protection: true
      member
    end
  end

  def scriptcamhack
    head :ok, content_type: "text/html"
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
