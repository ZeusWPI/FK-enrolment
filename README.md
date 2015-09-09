# [FK-enrolment](https://registratie.fkgent.be) [![Analytics](https://ga-beacon.appspot.com/UA-25444917-6/ZeusWPI/FK-enrolment/README.md?pixel)](https://github.com/igrigorik/ga-beacon) [![Code Climate](https://codeclimate.com/github/ZeusWPI/FK-enrolment/badges/gpa.svg)](https://codeclimate.com/github/ZeusWPI/FK-enrolment) [![Coverage Status](https://coveralls.io/repos/ZeusWPI/FK-enrolment/badge.png?branch=master)](https://coveralls.io/r/ZeusWPI/FK-enrolment) [![Build Status](https://travis-ci.org/ZeusWPI/FK-enrolment.png?branch=master)](https://travis-ci.org/ZeusWPI/FK-enrolment)



FK-enrolment werd ontwikkeld door [Zeus WPI](http://zeus.ugent.be) voor het [FaculteitenKonvent Gent](http://fkgent.be).
Alle code is eigendom van hun respectievelijke eigenaars, bij vragen: contacteer fk-enrolment@zeus.ugent.be.

## API-documentatie

FK-kringen kunnen toegang krijgen tot een REST API langswaar ze alle informatie over hun leden kunnen opvragen en wijzigen. Elke methode van de API vereist de aanwezigheid van een API-sleutel, deze is kring-specifiek en kan verkregen worden via het controle-paneel van de applicatie.

De voornaamste methodes worden hieronder beschreven:

*   *GET /api/v2/members.json?key=x*

    Een lijst van alle geregistreerde leden en hun geassocieerde kaart. Elk element
    van de array bevat een hash met alle attributen, waaronder ook een ID die in andere
    methods gebruikt kan worden.

    Aan deze methode kunnen ook enkele fiters worden doorgegeven als URL-parameter om zo leden op te zoeken. Beschikbare filters:

    * ``card`` (number): FK-kaart nummer
    * ``first_name`` (string): Deel van de voornaam
    * ``last_name`` (string): Deel van de familienaam
    * ``email`` (string): E-mailadres
    * ``ugent_nr`` (string): UGent nummer

*   *GET /api/v2/members/[member_id].json?key=x*

    Haal de informatie van 1 lid op.

*   *POST /api/v2/members.json?key=x*

    Voeg een nieuw lid toe. Als antwoord wordt alle opgeslagen informatie over het lid gegeven, waaronder ook het toegekende id. POST-parameters kunnen zowel op de klassieke manier of als een JSON-object (met correcte headers) verstuurd worden. Verplichte parameters zijn:

    * ``first_name`` (string)
    * ``last_name`` (string)
    * ``ugent_nr`` (string)
    * ``email`` (string)
    * ``date_of_birth`` (date, enkel verplicht bij ISIC)
    * ``photo_url`` (string, enkel verplicht bij ISIC)
    * ``home_address`` (string, enkel verplicht bij ISIC,
      formaat: ``[straat] [nummer]\r\n[postcode] [gemeente]``)

    Andere optionele velden zijn:
    ``email`` (string), ``sex`` (m of f), ``phone`` (string), ``studenthome_address`` (string)

    Kringen die beide kaarttypes toelaten en de kassa in de backend (https://registratie.fkgent.be/backend)
    gebruiken (dus niet via onderstaande methode) moeten ``card_type_preference`` meegeven
    (mogelijke waarden: ``isic`` of ``fk``). Dit veld geeft aan welke kaartttype toegekend zal worden
    aan de kassa.

    Volgende velden kunnen doorgegeven worden bij een ISIC-registratie:
    ``isic_newsletter`` (boolean), ``isic_mail_card`` (boolean)

*   *POST /api/v2/members/[id]/card.json?key=x*

    Stel de kaartgegevens in van het lid [id]. Parameters zijn

    * Voor FK-kaarten:
      * ``number`` (int): toegekende FK-kaart nummer
      * ``status`` (paid of unpaid): betalingsstatus
    * Voor ISIC-kaarten:
      * ``status`` (paid of unpaid): betalingsstatus

    Als beide kaarttypes toegelaten zijn, gebruik dan ``card_type`` (isic of fk)
    om het gewenste kaarttype door te geven.

*   *GET /api/v2/club.json?key=x*

    Geeft informatie terug over de kring die deze API-sleutel identificeert, bevat ook enkele configuraties van de kring zoals ISIC-voorkeuren.
