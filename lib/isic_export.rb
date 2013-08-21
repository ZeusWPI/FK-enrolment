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
      convert_request_keys_to: :camelcase
    )
    @defaults = {
      username: Rails.application.config.isic_soap_user,
      password: Rails.application.config.isic_soap_password,
    }
  end

  def submit(member, card)
    params = @defaults.merge({
      card_type: "ISIC",
      student_city: "Gent",
      school: "Universiteit Gent",

      client_id: "FK", # TODO: get client id from club
      member_number: card.number,
      isic_card_number: card.isic_number, # TODO: what if empty?
      course: member.club.full_name,
      year: "1", # TODO: check if this a good default

      first_name: member.first_name,
      last_name: member.last_name,
      birth_date: member.date_of_birth.strftime("%d/%m/%Y"),
      birth_place: "",
      gender: member.sex.upcase,
      nationality: "",
      language: "NL",

      street: member.street,
      postal_code: member.postal_code,
      city: member.city,

      email: member.email,
      phone_number: member.phone,
  
      # TODO: crop correctly according to spec
      photo: ActiveSupport::Base64.encode64(open(member.photo_file_name).string),
      image_extension: "jpg",

      is_student: "1",
      send_to_home: member.isic_mail_card ? "1" : "0",
      optin: member.isic_newsletter ? "1" : "0",
      # TODO: figure this one out correctly
      type: member.current_card.isic_number.blank? ? "REQUESTED" : "REVALIDATE",
      promotion_code: "",
      optin_third: "0",
      special: "1",
    })

    client.call(:add_isic_registration, message: params)
    end
  rescue Savon::Error => error
    Logger.log error
  end
end
