class CitylifeExport
  def submit(member, card)
    HTTParty.post(Rails.application.config.citylife_url + '/create',
        body: {
            club: member.club.internal_name,
            first_name: member.first_name,
            last_name: member.last_name,
            year: member.last_registration,
            date_of_birth: member.date_of_birth,
            key: Rails.application.secrets.citylife_key
        })
  end
end