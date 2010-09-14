<div class="cols">
    <p class="col col-2">
    <img src="<?php echo site_url('assets/schilden/'.$kring->kringname.'.jpg'); ?>"
             alt="<?php echo $kring->kort; ?>" class="image-center image-header-offset" />
    </p>
    <div class="col col-5 col-last">
    <h2>ISIC kaart</h2>

    <p>Uitleg over ISIC kaart hier</p>

    <p><?php echo $settings->isic_text; ?></p>

    <?php echo form_open(uri_string()); ?>

    <p>
        <?php echo form_checkbox(array('name' => 'isic_newsletter', 'id' => 'newsletter'),
            'yes', set_value('isic_newsletter', 'yes') == 'yes'); ?>
        <?php echo form_label('Ja, ik wil de ISIC nieuwsbrief ontvangen.', 'newsletter'); ?>
    </p>

    <p>
    <?php if($allow_choice) : ?>
        <?php echo form_submit('isic_true', 'Ja, ik wens een ISIC kaart'); ?>
        <?php echo form_submit('isic_false', 'Nee, ik wens geen ISIC kaart'); ?>
    <?php else : ?>
        <?php echo form_submit('isic_true', 'Verdergaan met registratie'); ?>
    <?php endif; ?>
    </p>

    <?php echo form_close(); ?>

    </div>
</div>
