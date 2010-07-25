<h2>Backend &raquo; instellingen</h2>

<div class="cols">
    <p class="col col-2">
        <img src="http://www.fkgent.be/intranet/schild/k.<?php echo $kring->kringname; ?>/h.180/w.110"
             alt="<?php echo $kring->kort; ?>" class="image-center" />
    </p>
    <div class="col col-4 col-last">
        <p><?php echo anchor('/backend', '&laquo; Terug naar het overzicht'); ?></p>

        <?php echo form_open('/backend/instellingen'); ?>

        <dl class="form">
            <dt><?php echo form_label('Website actief?:', 'enable_gui'); ?></dt>
            <dd>
                <?php echo form_checkbox('enable_gui', 1, set_value('enable_gui', $settings->enable_gui) == 1); ?>
                <?php echo form_error('enable_gui', '<div class="error">', '</div>'); ?>
            </dd>
            <dt><?php echo form_label('APi actief?:', 'enable_gui'); ?></dt>
            <dd>
                <?php echo form_checkbox('enable_api', 1, set_value('enable_api', $settings->enable_api) == 1); ?>
                <?php echo form_error('enable_api', '<div class="error">', '</div>'); ?>
            </dd>
            <dt><?php echo form_label('API-sleutel:', 'api_key'); ?></dt>
            <dd>
                <?php echo form_input('api_key', set_value('api_key', $settings->api_key)); ?>
                <?php echo form_error('api_key', '<div class="error">', '</div>'); ?>
            </dd>
        </dl>

        <p><?php echo form_submit('submit', 'Wijzigen'); ?></p>

        <?php echo form_close(); ?>
    </div>
</div>