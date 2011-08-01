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
  Club.update_all(:registration_method => "website")
  api_clubs = %w(Wina VTK VEK VRG VGK-fgen)
  Club.where(:internal_name => api_clubs).update_all(:registration_method => "api")
  Club.where(:internal_name => %w(Dentalia Slavia)).update_all(:registration_method => "none")
  isic_clubs = %w(VDK VLK VEK GFK Dentalia Politeia Hilok)
  Club.where(:internal_name => isic_clubs).update_all(:uses_isic => true)
end


def text_spec(name, question = '', required = false)
  ExtraAttributeSpec.create!(:name => name, :field_type => 'text', :text => question, :required => required,
                             :values => []
                            )
end

def check_box_spec(name, question = '', values = [], required = false) 
  ExtraAttributeSpec.create!(:name => name, :field_type => 'check_boxes', :required => false, 
                             :values => values, :text => question
                            )
end

c = Club.where(:internal_name => 'Chemica').first
c.extra_attributes << check_box_spec("test", "hallokes, tis een vraagje", ['optie 1', 'optie 2'])
c.save!

c = Club.where(:internal_name => 'VPPK').first
c.extra_attributes << check_box_spec('Vink aan', 'Ik wil op de hoogte gehouden worden van:',
      ['Feest (fuiven, galabal, cocktailavond, …)',
       'Sport (paintball, interfacultair tornooi, 12-urenloop, …)',
       'Excursie (citytrip, skireis, surfreis, …)',
       'Cultuur (filmavond, museumbezoek, …)',
       'Doop / Ontgroening',
       'Cantus'
      ])
c.extra_attributes << text_spec('', 'Heb je nog suggesties om onze werking beter af te stemmen op jouw wensen (nieuwe activiteiten, leuke sporten, thema’s voor een fuif/clubavond, cultuuruitstapjes, …)?')
c.save!


c = Club.where(:internal_name => 'VLK').first
c.extra_attributes << check_box_spec('Mail', 'Ik wil graag via mail informatie ontvangen over VLK-activiteiten', ['ja'])

c.extra_attributes << check_box_spec('Mogelijkheden', 'Ja, de VLK mag contact met mij opnemen om te shiften op:', 
                                     ['Paviljoenfuiven','Vooruitfuiven', 'Het Galabal', 'Cultuuractiviteiten',
                                      'Eventuele andere VLK-activiteiten'
                                     ]
                                    )
c.extra_attributes << check_box_spec('Tapervaring', 'Ik heb tapervaring?', ['ja'])
c.extra_attributes << check_box_spec('Mail', 'Ik heb interesse om mee te schrijven aan De Groei, het clubblad van de VLK (Via mail word ik op de hoogte gehouden van de deadlines en desgewenst neem ik deel aan semestriële redactievergaderingen)', ['ja'])
c.extra_attributes << check_box_spec('Mail', 'De VLK mag mij contacteren voor deelname aan sporttoernooien tegen andere faculteitskringen', ['ja'])
c.extra_attributes << text_spec('Sporten', 'Indien ja: vul hier de sporten die u beoefent in en specificeer het niveau.')
c.save!

c = Club.where(:internal_name => 'Hilok').first
c.extra_attributes << check_box_spec('Sporten', 'Welke sport beoefen je?',
                                     ['Veldvoetbal',
                                      'Minivoetbal',
                                      'Basketbal',
                                      'Volleybal',
                                      'Badminton',
                                      'Zwemmen',
                                      'Hardlopen',
                                      'Veldlopen',
                                      'Rugby',
                                      'Tafeltennis',
                                     ]
                                    )
c.extra_attributes << check_box_spec('', 'Heb je interesse om mee te doen aan de interfacultaire competities?', ['ja'])
c.save!


