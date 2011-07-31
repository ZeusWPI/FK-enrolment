# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# SELECT kort AS name, lang AS full_name, kringname AS internal_name, descr AS description, url AS url
# FROM kringen WHERE actief =1
clubs = [
  ["VGK", "Vlaamse Geneeskundige Kring", "VGK-fgen", "faculteitskring voor de studenten Geneeskunde", "http://www.vgk-online.com"],
  ["Chemica", "Chemica", "Chemica", "faculteitskring van de studenten Chemie, Biotechnologie en Biochemie", "http://fkserv.ugent.be/chemica/"],
  ["Dentalia", "Dentalia", "Dentalia", "faculteitskring van de studenten Tandheelkunde", "http://www.dentalia.be"],
  ["GBK", "Gentse Biologische Kring", "GBK", "faculteitskring van de studenten Biologie aan de UGent", "http://www.biologie-gent.be"],
  ["GFK", "Gentse Farma Kring", "GFK", "faculteitskring voor de studenten Farmaceutische Wetenschappen", "http://www.gentsefarmakring.be"],
  ["Geografica", "Geografica", "Geografica", "faculteitskring van de studenten Geografie en Landmeetkunde", "http://www.geografica.be"],
  ["Geologica", "Geologica", "Geologica", "faculteitskring van de studenten Geologie", "http://www.geologica-gent.be"],
  ["Hilok", "Hoger instituut voor Lichamelijke Opvoeding en Kiné", "Hilok", "faculteitskring van de studenten Lichamelijke Opvoeding en Kinesitherapie", "http://www.hilokgent.be"],
  ["KHK", "KunstHistorische Kring", "KHK", "faculteitskring van de studenten Kunstwetenschappen en Archeologie", "http://fkserv.ugent.be/khk/"],
  ["KMF", "Kring Moraal en Filosofie", "KMF", "faculteitskring van de studenten Wijsbegeerte, Moraalwetenschappen en Vergelijkende cultuurwetenschappen.", "http://www.kmfgent.be/"],
  ["Lombrosiana", "Lombrosiana", "Lombrosiana", "faculteitskring van de studenten Criminologie", "http://www.lombrosiana.be"],
  ["OAK", "Oosterse Afrikaanse Kring", "OAK", "faculteitskring van de studenten Oosterse Talen en Culturen, Afrikaanse Talen en Culturen.", "http://fkserv.UGent.be/oak"],
  ["Politeia", "Politeia", "Politeia", "faculteitskring van de studenten Politieke en Sociale Wetenschappen", "http://www.politeia-gent.be/"],
  ["Slavia", "Slavia", "Slavia", "faculteitskring van de studenten Oost-Europese Talen en Culturen", "http://www.slavia-gent.be"],
  ["VBK", "Vlaamse Biomedische Kring", "VBK", "faculteitskring van de studenten Biomedische Wetenschappen", "http://fkserv.ugent.be/vbk"],
  ["VDK", "Vlaamse Diergeneeskundige Kring", "VDK", "faculteitskring van de studenten Diergeneeskunde", "http://www.vdk-diergeneeskunde.be"],
  ["VEK", "Vlaamse Economische Kring", "VEK", "faculteitskring van de studenten Economie", "http://www.vek.be/"],
  ["VGK", "Vlaamse Geschiedkundige Kring", "VGK-flwi", "faculteitskring van de studenten Geschiedenis", "http://www.vgkgent.be"],
  ["VLK", "Vlaamse Levenstechnische Kring", "VLK", "faculteitskring van de studenten Bio-Ingenieurswetenschappen", "http://www.boerekot.be/"],
  ["VLAK", "Vlaamse Logopedische en Audiologische Kring", "VLAK", "faculteitskring van de studenten Logopedie en Audiologie", "http://www.vlak.be"],
  ["VPPK", "Vlaamse Psychologische en Pedagogische Kring", "VPPK", "faculteitskring van de studenten Psychologische en Pedagogische Wetenschappen", "http://www.vppk.be"],
  ["VRG", "Vlaams Rechtsgenootschap", "VRG", "faculteitskring van de studenten Rechten", "http://www.vrg-gent.be"],
  ["VTK", "Vlaamse Technische Kring", "VTK", "faculteitskring van de studenten Toegepaste Wetenschappen", "http://www.vtk.ugent.be"],
  ["WiNA", "WiNA", "Wina", "faculteitskring van de studenten Wiskunde, Fysica, Sterrenkunde en Informatica", "http://wina.ugent.be"],
  ["Filologica", "Filologica", "Filologica", "faculteitskring van de studenten Taal en Letterkunde: Twee Talen (Germaanse, Romaanse en Klassieke Talen)", "http://www.filologica.be"]
]
clubs.each do |c|
  Club.create!(:name => c[0], :full_name => c[1], :internal_name => c[2], :description => c[3], :url => c[4])
end

if Rails.env.development?
  Club.where(:internal_name => "Wina").first.update_attributes!({
    :registration_method => "api",
    :api_key => "12345678"
  })
  website_clubs = %w(Chemica Dentalia Filologica GBK GFK Geografica Geologica)
  Club.where(:internal_name => website_clubs).update_all(:registration_method => "website")
  Club.where(:internal_name => 'Chemica').update_all(:uses_isic => true)
else
  Club.where(:internal_name => %w(VLK Hilok)).update_all(:registration_method => "website")
end
