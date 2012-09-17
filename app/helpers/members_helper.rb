module MembersHelper
  def human_isic_status(status)
    {
      'request'   => 'aanvraag nog niet doorgegeven',
      'requested' => 'aanvraag is doorgegeven',
      'revalidate' => 'kaart moet hervalideerd worden',
      'revalidated' => 'kaart is hervalideerd'
    }[status]
  end

  def human_card_status(status)
    {
      'paid'   => 'betaald',
      'unpaid' => 'onbetaald',
    }[status]
  end
end
