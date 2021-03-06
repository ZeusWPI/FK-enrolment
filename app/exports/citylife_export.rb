class CitylifeExport
  def submit(member, card)
    response = HTTParty.post(Rails.application.config.citylife_url,
                  body: {
                      card: {
                          club: member.club.internal_name,
                          first_name: member.first_name,
                          last_name: member.last_name,
                          year: member.last_registration,
                          date_of_birth: member.date_of_birth,
                          photo_url: "#{ Rails.application.config.base_url }#{ member.photo && member.photo.url }",
                      },
                      key: Rails.application.secrets.varrock_key
                  })

    if response.code == 201 # Created
      card.citylife_exported = true
      card.save
    end
  end
end