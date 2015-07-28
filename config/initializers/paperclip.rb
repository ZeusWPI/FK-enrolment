Paperclip::Attachment.class_eval {
  @default_options = self.default_options.merge({
    :url => "/data/:class/:attachment/:hash_prefix/:id-:hash",
    :hash_data => ":class/:attachment/:id/:filename/:style",
    :hash_secret => "oJqDNFLYmaRb4CEqfodA3pbLhTtQF9PV2hMt8xBAXWQAf"
  })
}

Paperclip.interpolates :hash_prefix do |attachment, style|
  attachment.hash_key(style)[0,2]
end


# Paperclip doesn't correctly recognize XLS spreadsheets created by
# Spreadsheet. See https://github.com/zdavatz/spreadsheet/issues/97
Paperclip.options[:content_type_mappings] = {
    :xls => "CDF V2 Document, No summary info"
}
