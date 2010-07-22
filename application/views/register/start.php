<h2>Registreren</h2>

<div class="cols">
    <p class="col col-2">
        <img src="http://www.fkgent.be/intranet/schild/k.<?php echo $kring->kringname; ?>/h.180" 
             alt="<?php echo $kring->kort; ?>" class="image-center" />
    </p>
    <div class="col col-4 col-last">

<p>Via deze website kan je je registreren als lid van de <em><?php echo $kring->lang; ?></em>, de
<?php echo lcfirst($kring->descr); ?>.</p>

<p>Is dit niet de juiste kring? Ga dan terug naar de <?php echo anchor('', 'startpagina'); ?>.</p>

<h3>Registreren</h3>

<p>Om te registreren heb je 2 keuzes: ofwel doe je dit met je UGentNet gebruikersnaam en wachtwoord,
ofwel geef je zelf het stamnummer in dat je op studentenkaart vindt.</p>

<ul id="registration-selector">
    <li><a href="<?php echo site_url('registratie/via-cas'); ?>">
        Ik ken mijn <em>UGentNet gebruikersnaam</em> en <em>wachtwoord</em> en wil
        daarmee registreren.
    </a></li>
    <li><a href="<?php echo site_url('registratie/via-ugentnr'); ?>">
        Ik gebruik het <em>stamnummer op mijn studentenkaart.</em>
    </a></li>
</ul>

    </div>
</div>

<style type="text/css">
#registration-selector li {
    margin: 15px 0;
    border: 1px solid #AAA;
}

#registration-selector li a {
    display: block;
    color: #000;
    padding: 15px 20px 15px 42px;
    background-image: url('assets/selector-arrow.png');
    background-repeat: no-repeat;
    background-position: 14px center;
    background-color: #EEE;
}

#registration-selector li a:hover {
    background-color: #F9F9F9;
    text-decoration: none;
}

</style>