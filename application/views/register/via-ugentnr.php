<h2>Registreren via ugent-nr</h2>
<div class="cols">
    <p class="col col-2">
    <img src="http://www.fkgent.be/intranet/schild/k.<?php echo $kring->kringname; ?>/h.180" 
             alt="<?php echo $kring->kort; ?>" class="image-center" />
    </p>
    <div class="col col-4 col-last">

    <p>Vul onderstaand formulier in om je te registreren</p>
<?php echo form_open('/registratie/via_ugentnr'); ?>
    <?php echo form_label('Geef uw stamnummer in','stamnummer'); ?>
    <?php echo form_input('stamnummer'); ?>
    <?php echo form_submit('submit','Registreer'); ?>
<?php echo form_close(); ?>
    </div>
</div>

