module Backend::HomeHelper

  def human_isic_text(status)
    hash = {
      'request'   => 'aanvraag nog niet doorgegeven',
      'requested' => 'aanvraag is doorgegeven',
      'printed'   => 'kaart is afgedrukt',
      'delivered' => 'kaart is afgeleverd'
    }
    hash[status]
  end
end
