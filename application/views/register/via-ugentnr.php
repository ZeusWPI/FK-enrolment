<h2>Registreren via ugent-nr</h2>
<div class="cols">
    <p class="col col-2">
    <img src="http://www.fkgent.be/intranet/schild/k.<?php echo $kring->kringname; ?>/h.180/w.110"
             alt="<?php echo $kring->kort; ?>" class="image-center" />
    </p>
    <div class="col col-4 col-last">

    <p>Vul onderstaand formulier in om je te registreren. Velden met een * zijn verplicht </p>
<?php echo validation_errors() ?>
<?php echo form_open('/registratie/via_ugentnr'); ?>
    <p><?php echo form_label('* Geef uw stamnummer in:','stamnummer'); ?>
    <?php echo form_input('stamnummer'); ?></p>
    <p><?php echo form_label('* Geef uw voornaam in:','voornaam'); ?>
    <?php echo form_input('voornaam'); ?></p>
    <p><?php echo form_label('* Geef uw familienaam in:','familienaam'); ?>
    <?php echo form_input('familienaam'); ?></p>
    <p><?php echo form_label('Geef uw emailadres in:','emailadres'); ?>
    <?php echo form_input('emailadres'); ?></p>
    <p><?php echo form_label('Geef uw telefoonnummer in:','telefoonnummer'); ?>
    <?php echo form_input('telefoonnummer'); ?></p>
    <p><?php echo form_label('Geef uw kotadres in:','kotadres'); ?>
    <?php echo form_input('kotadres'); ?></p>
    <p><?php echo form_label('Geef uw thuisadres in:','thuisadres'); ?>
    <?php echo form_input('thuisadres'); ?></p>

    <div><?php echo form_submit('submit','Registreer'); ?></div>
<?php echo form_close(); ?>
    </div>
</div>

