class IsicExportJob
  def perform
    export = IsicExport.create_export
    # TODO: mail url to the isic person
  end
end
