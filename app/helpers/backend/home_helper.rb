module Backend::HomeHelper
  def human_isic_status(status)
    hash = {
      'request'   => 'aanvraag nog niet doorgegeven',
      'requested' => 'aanvraag is doorgegeven',
      'printed'   => 'kaart is afgedrukt',
      'delivered' => 'kaart is afgeleverd'
    }
    hash[status]
  end

  def human_card_status(status)
    hash = {
      'paid'   => 'betaald',
      'unpaid' => 'onbetaald',
    }
    hash[status]
  end
end
