<div class="cols">
    <p class="col col-2">
    <img src="http://www.fkgent.be/intranet/schild/k.<?php echo $kring->kringname; ?>/h.180/w.120"
             alt="<?php echo $kring->kort; ?>" class="image-center image-header-offset" />
    </p>
    <div class="col col-5 col-last">
    <h2>ISIC kaart</h2>

    <p>Uitleg over ISIC kaart hier</p>

    <?php echo form_open(uri_string()); ?>

    <p>
        <?php echo form_submit('isic_true', 'Ja, ik wens een ISIC kaart'); ?>
        <?php echo form_submit('isic_false', 'Nee, ik wens geen ISIC kaart'); ?>
    </p>

    <?php echo form_close(); ?>

    </div>
</div>