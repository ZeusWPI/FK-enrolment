Paperclip.interpolates :hash_prefix do |attachment, style|
  attachment.hash_key(style)[0,2]
end
