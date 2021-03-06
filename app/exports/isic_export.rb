class IsicExport
  def initialize
    @client = Savon.client(
      wsdl: Rails.application.secrets.isic_api_wsdl,
      convert_request_keys_to: :none
    )
    @defaults = {
      username: Rails.application.secrets.isic_api_user,
      password: Rails.application.secrets.isic_api_password,

      cardType: "ISIC",
      StudentCity: "Gent",
      School: "Universiteit Gent",
    }
  end

  def submit(member, card)
    return if card.academic_year != Member.current_academic_year
    return if not ['request'].include? card.isic_status
    return if card.status != 'paid'

    state_info = {
      'request' => ['REQUESTED', 'requested'],
    }

    params = @defaults.merge({
      ClientID: member.club.isic_name,
      MemberNumber: card.number,
      ISICCardNumber: "",
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
      Year: "0",
      sendToHome: member.isic_mail_card ? "1" : "0",
      promotionCode: "",
      Optin: member.isic_newsletter ? "1" : "0",
      postOptOut: "1",
      postOptOutThird: "1",
      special: "1"
    })

    photo = File.read(member.photo.path(:cropped), mode: 'rb')
    params.update({
      Photo: Base64.encode64(photo),
      ImageExtension: "jpg"
    })

    response = @client.call(:add_isic_registration, message: params)
    result = response.body[:add_isic_registration_response][:add_isic_registration_result]

    # Response is either "OKS 000 000 000 000 A"
    # or "ASK FOR YOUR REVALIDATION STICKER"
    if result[0..1] == 'OK' or result[0..2] == 'ASK'
      if result[0..1] == 'OK'
        card.isic_number = result[2..-1]
      end

      # Update card state
      card.isic_status = state_info[card.isic_status][1]
      card.isic_exported = true
      card.save
    else
      raise result
    end
  end
end
