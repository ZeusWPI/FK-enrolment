# [FK-enrolment](http://registratie.fkgent.be)

FK-enrolment werd ontwikkeld door [Zeus WPI](http://zeus.ugent.be) voor het [FaculteitenKonvent Gent](http://fkgent.be).
Alle code is eigendom van hun respectievelijke eigenaars, bij vragen: contacteer fk-enrolment@zeus.ugent.be.

## API-documentatie

FK-kringen kunnen toegang krijgen tot een REST API langswaar ze alle informatie over hun leden kunnen
opvragen en wijzigen. Elke methode van de API vereist de aanwezigheid van een API-sleutel, deze is kring-specifiek en kan verkregen worden via het controle-paneel van de applicatie.

De voornaamste methodes worden hieronder beschreven:

*   *GET /api/v2/members.json?key=x*

    Een lijst van alle geregistreerde leden en hun geassocieerde kaart. Elk element
    van de array bevat een hash met alle attributen, waaronder ook een ID die in andere
    methods gebruikt kan worden.

*   *GET /api/v2/members/[member_id].json?key=x*

    Haal de informatie van 1 lid op.

*   *POST /api/v2/members.json?key=x*

    Voeg een nieuw lid toe. Verplichte velden (in de POST-body):

    * first_name (string)
    * last_name (string)
    * ugent_nr (string)

    Andere optionele velden zijn:

    * email (string, valid adres)
    * sex ('m' of 'f')
    * phone (string)
    * date_of_birth (date)
    * home_address (string)
    * studenthome_address (string)
    * isic_newsletter (boolean)
    * isic_mail_card (boolean)
