<div class="cols">
    <p class="col col-2">
        <img src="<?php echo site_url('assets/schilden/'.$kring->kringname.'.jpg'); ?>"
             alt="<?php echo $kring->kort; ?>" class="image-center image-header-offset" />
    </p>
    <div class="col col-5 col-last">
        <h2>Backend &raquo; instellingen</h2>

        <p><?php echo anchor('/backend', '&laquo; Terug naar het overzicht'); ?></p>

        <?php echo form_open('/backend/instellingen'); ?>

        <p>Kies hier welke instellingen van toepassing zijn voor uw kring. Indien u
            wenst kan u de teksten in het registratieproces aanpassen voor uw kring.</p>

        <dl class="form">
            <dt><?php echo form_label('Website actief?:', 'enable_gui'); ?></dt>
            <dd>
                <?php echo form_checkbox('enable_gui', 1, set_value('enable_gui', $settings->enable_gui) == 1); ?>
                <?php echo form_error('enable_gui', '<div class="error">', '</div>'); ?>
            </dd>
            <dt><?php echo form_label('API actief?:', 'enable_gui'); ?></dt>
            <dd>
                <?php echo form_checkbox('enable_api', 1, set_value('enable_api', $settings->enable_api) == 1); ?>
                <?php echo form_error('enable_api', '<div class="error">', '</div>'); ?>
            </dd>
            <dt><?php echo form_label('API-sleutel:', 'api_key'); ?></dt>
            <dd>
                <code><?php echo $settings->api_key; ?></code>
            </dd>
            <dt><?php echo form_label('ISIC voorkeur:', 'isic'); ?></dt>
            <dd>
                <?php echo form_dropdown('isic', array('yes' => 'ISIC-kaart voor elk lid',
                    'optional' => 'Elk lid kiest zelf', 'no' => 'ISIC wordt niet aangeboden'),
                        $settings->isic); ?>
            </dd>
        </dl>

        <dl>
            <dt><?php echo form_label('ISIC tekst', 'isic_text'); ?></dt>
            <dd>
                <?php echo form_textarea(array('name' => 'isic_text', 'rows' => 3), $settings->isic_text); ?>
            </dd>
            <dt><?php echo form_label('Bevestingstekst', 'confirmation_text'); ?></dt>
            <dd>
                <?php echo form_textarea(array('name' => 'confirmation_text', 'rows' => 5), $settings->confirmation_text); ?>
            </dd>
        </dl>

        <p><?php echo form_submit('submit', 'Wijzigen'); ?></p>

        <?php echo form_close(); ?>
    </div>
</div>