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
  Club.create!(:name => c[0], :full_name => c[1], :internal_name => c[2],
               :description => c[3], :url => c[4], :api_key => SecureRandom::hex(16))
end
data =
{
  "Chemica"     => 10001..11000,
  "Dentalia"    => 11001..12000,
  "Filologica"  => 12001..14000,
  "GBK"         => 14001..15000,
  "GFK"         => 15001..16000,
  "Geografica"  => 16001..17000,
  "Geologica"   => 17001..18000,
  "Hilok"       => 18001..20000,
  "KMF"         => 20001..21000,
  "KHK"         => 21001..22000,
  "Lombrosiana" => 22001..23000,
  "OAK"         => 23001..24000,
  "Politeia"    => 24001..26000,
  "Slavia"      => 26001..27000,
  "VBK"         => 27001..28000,
  "VDK"         => 28001..30000,
  "VEK"         => 30001..32000,
  "VGK-fgen"    => 32001..34000,
  "VGK-flwi"    => 34001..36000,
  "VLK"         => 36001..38000,
  "VLAK"        => 38001..39000,
  "VPPK"        => 39001..42000,
  "VRG"         => 42001..44000,
  "VTK"         => 44001..46000,
  "Wina"        => 46001..47000
}

data.each do |name, range|
  c = Club.find_by_internal_name(name)
  c.range_lower = range.begin
  c.range_upper = range.end
  c.save!
end

Club.update_all(:registration_method => "website")
api_clubs = %w(Wina VTK VEK VRG VGK-fgen)
Club.where(:internal_name => api_clubs).update_all(:registration_method => "api")
Club.where(:internal_name => %w(Dentalia Slavia)).update_all(:registration_method => "none")
isic_clubs = %w(VDK VLK VEK GFK Dentalia Politeia Hilok)
Club.where(:internal_name => isic_clubs).update_all(:uses_isic => true)

c = Club.where(:internal_name => 'Chemica').first
c.extra_attributes << ExtraAttributeSpec.build("Hallo daar, dit is een tekstbericht", nil)
c.extra_attributes << ExtraAttributeSpec.build("Ja, ik wil inschrijven op de nieuwsbrief", :checkbox)
c.extra_attributes << ExtraAttributeSpec.build("Ik wil op de hoogte gehouden worden van", :checkbox_list, [
  'Feest (fuiven, galabal, cocktailavond, …)',
  'Sport (paintball, interfacultair tornooi, 12-urenloop, …)',
  'Excursie (citytrip, skireis, surfreis, …)',
  'Cultuur (filmavond, museumbezoek, …)',
  'Doop / Ontgroening',
  'Cantus'])
c.extra_attributes << ExtraAttributeSpec.build("Ik beoefen volgende sporten", :checkbox_grid,
  %w(Veldvoetbal Minivoetbal Basketbal Volleybal Badminton Zwemmen) +
  %w(Hardlopen Veldlopen Rugby Tafeltennis))
c.extra_attributes << ExtraAttributeSpec.build("1 lijntje tekst", :text)
c.extra_attributes << ExtraAttributeSpec.build("Vrij veld voor uw liefdesbrieven", :textarea)
c.extra_attributes << ExtraAttributeSpec.build("Studierichting", :study,
  %w(Wiskunde Informatica Fysica), true)
c.save!
