Paperclip::Attachment.class_eval {
  @default_options = self.default_options.merge({
    :url => "/data/:attachment/:hash_prefix/:id-:hash.:extension",
    :hash_secret => "oJqDNFLYmaRb4CEqfodA3pbLhTtQF9PV2hMt8xBAXWQAf"
  })
}

Paperclip.interpolates :hash_prefix do |attachment, style|
  attachment.hash(style)[0,2]
end
