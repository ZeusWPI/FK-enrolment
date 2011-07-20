# encoding: UTF-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# SELECT kort AS name, lang AS full_name, kringname AS internal_name, descr AS description, url AS url
# FROM kringen WHERE actief =1

clubs = [
  ["VGK", "Vlaamse Geneeskundige Kring", "VGK-fgen", "Faculteitskring voor de studenten Geneeskunde", "http://www.vgk-online.com"],
  ["Chemica", "Chemica", "Chemica", "Faculteitskring van de studenten Chemie, Biotechnologie en Biochemie", "http://fkserv.ugent.be/chemica/"],
  ["Dentalia", "Dentalia", "Dentalia", "Faculteitskring van de studenten Tandheelkunde", "http://www.dentalia.be"],
  ["GBK", "Gentse Biologische Kring", "GBK", "Faculteitskring van de studenten Biologie aan de UGent", "http://www.biologie-gent.be"],
  ["GFK", "Gentse Farma Kring", "GFK", "Faculteitskring voor de studenten Farmaceutische Wetenschappen", "http://www.gentsefarmakring.be"],
  ["Geografica", "Geografica", "Geografica", "Faculteitskring van de studenten Geografie en Landmeetkunde", "http://www.geografica.be"],
  ["Geologica", "Geologica", "Geologica", "Faculteitskring van de studenten Geologie", "http://www.geologica-gent.be"],
  ["Hilok", "Hoger instituut voor Lichamelijke Opvoeding en Kiné", "Hilok", "Faculteitskring van de studenten Lichamelijke Opvoeding en Kinesitherapie", "http://www.hilokgent.be"],
  ["KHK", "KunstHistorische Kring", "KHK", "Faculteitskring van de studenten Kunstwetenschappen en Archeologie", "http://fkserv.ugent.be/khk/"],
  ["KMF", "Kring Moraal en Filosofie", "KMF", "Faculteitskring van de studenten Wijsbegeerte, Moraalwetenschappen en Vergelijkende cultuurwetenschappen.", "http://www.kmfgent.be/"],
  ["Lombrosiana", "Lombrosiana", "Lombrosiana", "Faculteitskring van de studenten Criminologie", "http://www.lombrosiana.be"],
  ["OAK", "Oosterse Afrikaanse Kring", "OAK", "Faculteitskring van de studenten Oosterse Talen en Culturen, Afrikaanse Talen en Culturen.", "http://fkserv.UGent.be/oak"],
  ["Politeia", "Politeia", "Politeia", "Faculteitskring van de studenten Politieke en Sociale Wetenschappen", "http://www.politeia-gent.be/"],
  ["Slavia", "Slavia", "Slavia", "Faculteitskring van de studenten Oost-Europese Talen en Culturen", "http://www.slavia-gent.be"],
  ["VBK", "Vlaamse Biomedische Kring", "VBK", "Faculteitskring van de studenten Biomedische Wetenschappen", "http://fkserv.ugent.be/vbk"],
  ["VDK", "Vlaamse Diergeneeskundige Kring", "VDK", "Faculteitskring van de studenten Diergeneeskunde", "http://www.vdk-diergeneeskunde.be"],
  ["VEK", "Vlaamse Economische Kring", "VEK", "Faculteitskring van de studenten Economie", "http://www.vek.be/"],
  ["VGK", "Vlaamse Geschiedkundige Kring", "VGK-flwi", "Faculteitskring van de studenten Geschiedenis", "http://www.vgkgent.be"],
  ["VLK", "Vlaamse Levenstechnische Kring", "VLK", "Faculteitskring van de studenten Bio-Ingenieurswetenschappen", "http://www.boerekot.be/"],
  ["VLAK", "Vlaamse Logopedische en Audiologische Kring", "VLAK", "Faculteitskring van de studenten Logopedie en Audiologie", "http://www.vlak.be"],
  ["VPPK", "Vlaamse Psychologische en Pedagogische Kring", "VPPK", "Faculteitskring van de studenten Psychologische en Pedagogische Wetenschappen", "http://www.vppk.be"],
  ["VRG", "Vlaams Rechtsgenootschap", "VRG", "Faculteitskring van de studenten Rechten", "http://www.vrg-gent.be"],
  ["VTK", "Vlaamse Technische Kring", "VTK", "Faculteitskring van de studenten Toegepaste Wetenschappen", "http://www.vtk.ugent.be"],
  ["WiNA", "WiNA", "Wina", "Faculteitskring van de studenten Wiskunde, Fysica, Sterrenkunde en Informatica", "http://wina.ugent.be"],
  ["Filologica", "Filologica", "Filologica", "Faculteitskring van de studenten Taal en Letterkunde: Twee Talen (Germaanse, Romaanse en Klassieke Talen)", "http://www.filologica.be"]
]
clubs.each do |c|
  Club.create(:name => c[0], :full_name => c[1], :internal_name => c[2], :description => c[3], :url => c[4])
end
