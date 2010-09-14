<div class="cols">
    <p class="col col-2">
        <img src="<?php echo site_url('assets/schilden/'.$kring->kringname.'.jpg'); ?>"
             alt="<?php echo $kring->kort; ?>" class="image-center image-header-offset" />
    </p>
    <div class="col col-5 col-last">

<h2>Inschrijven</h2>

<p>Via deze website kan je je registreren als lid van de <em><?php echo $kring->lang; ?></em>, de
<?php echo strtolower(substr($kring->descr, 0, 1)) . substr($kring->descr, 1); ?>.</p>

<p>Is dit niet de juiste kring? Ga dan terug naar de <?php echo anchor('', 'startpagina'); ?>.</p>

<p>Om te in te schrijven heb je 2 keuzes: ofwel doe je dit met je UGentNet gebruikersnaam en wachtwoord,
ofwel geef je zelf het stamnummer in dat je op studentenkaart vindt. Moest je nog niet inschreven zijn of geen UGent gegevens hebben,
dan kan je ook inschrijven maar zal je je stamnummer later nog moeten invullen.</p>


<ul id="registration-selector">
    <li><a href="<?php echo site_url('registratie/via_cas'); ?>">
        Ik ken mijn <em>UGentNet gebruikersnaam</em> en <em>wachtwoord</em> en wil
        daarmee registreren.
    </a></li>
    <li><a href="<?php echo site_url('registratie/via_ugentnr'); ?>">
        Ik gebruik het <em>stamnummer op mijn studentenkaart.</em>
    </a></li>
    <li><a href="<?php echo site_url('registratie/via_mail'); ?>">
        Ik heb nog geen UGent gegevens.
    </a></li>
</ul>

    </div>
</div>

<style type="text/css">
#registration-selector {
    margin-top: 20px;
    list-style-type: none;
    padding: 0;
}

#registration-selector li {
    margin: 15px 0;
    border: 1px solid #AAA;
}

#registration-selector li a {
    display: block;
    color: #000;
    padding: 15px 20px 15px 42px;
    background: url('assets/selector-arrow.png') no-repeat #EEE;
    background-position: 14px center;
}

#registration-selector li a:hover {
    background-color: #F9F9F9;
    text-decoration: none;
}

</style>
