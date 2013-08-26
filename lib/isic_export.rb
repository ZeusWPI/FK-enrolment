class IsicExport
  def self.export(member, card)
    if Rails.env.production?
      wsdl = "http://isicregistrations.guido.be/service.asmx?WSDL"
    else
      wsdl = "http://staging-isicregistrations.guido.be/service.asmx?WSDL"
    end

    export = IsicExport.new(wsdl)
    export.submit(member, card)
  end

  def initialize(wsdl_path)
    @client = Savon.client(
      wsdl: wsdl_path,
      convert_request_keys_to: :none
    )
    @defaults = {
      username: Rails.application.config.isic_soap_user,
      password: Rails.application.config.isic_soap_password,

      cardType: "ISIC",
      StudentCity: "Gent",
      School: "Universiteit Gent",
    }
  end

  def submit(member, card)
    return if card.academic_year != Member.current_academic_year
    return if not ['request', 'revalidate'].include? card.isic_status
    return if card.status != 'paid'

    state_info = {
      'request' => ['REQUESTED', 'requested'],
      'revalidate' => ['REVALIDATE', 'revalidated']
    }

    params = @defaults.merge({
      ClientID: "FK", # TODO: get client id from club
      MemberNumber: card.number,
      ISICCardNumber: card.isic_number, # TODO: what if empty?
      Course: member.club.full_name,
      type: state_info[card.isic_status][0],

      Firstname: member.first_name,
      Lastname: member.last_name,
      BirthDate: member.date_of_birth.strftime("%d/%m/%Y"),
      BirthPlace: "",
      Gender: member.sex.upcase,
      Nationality: "",
      language: "NL",

      Street: member.home_street,
      PostalCode: member.home_postal_code,
      City: member.home_city,
      email: member.email,
      PhoneNumber: "",

      isStudent: "1",
      Year: "0", # TODO: check if this a good default
      sendToHome: member.isic_mail_card ? "1" : "0",
      promotionCode: "",
      Optin: member.isic_newsletter ? "1" : "0",
      optinThird: "0",
      special: "1"
    })

    photo = File.read(member.photo.path(:cropped), mode: 'rb')
    params.update({
      Photo: ActiveSupport::Base64.encode64(photo),
      ImageExtension: "jpg"
    })

    response = @client.call(:add_isic_registration, message: params)
    result = response.body[:add_isic_registration_response][:add_isic_registration_result]

    if result[0] == 'S'
      # Update card state
      card.isic_status = state_info[card.isic_status][1]
      card.isic_number = result
      card.save
    else
      raise result
    end
end
