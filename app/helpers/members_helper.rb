module MembersHelper
  def human_isic_status(status)
    {
      'request'   => 'aanvraag nog niet doorgegeven',
      'requested' => 'aanvraag is doorgegeven',
      'printed'   => 'kaart is afgedrukt',
      'delivered' => 'kaart is afgeleverd'
    }[status]
  end

  def human_card_status(status)
    {
      'paid'   => 'betaald',
      'unpaid' => 'onbetaald',
    }[status]
  end
end
