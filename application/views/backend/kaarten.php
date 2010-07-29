<div class="cols">
    <p class="col col-2">
        <img src="http://www.fkgent.be/intranet/schild/k.<?php echo $kring->kringname; ?>/h.180/w.110"
             alt="<?php echo $kring->kort; ?>" class="image-center image-header-offset" />
    </p>
    <div class="col col-5 col-last">
        <h2>Backend &ndash; Kaarten toewijzen</h2>

        <p><?php echo anchor('backend', '&laquo; Terug naar het overzicht'); ?></p>

        <?php echo form_open('backend/kaarten'); ?>

        <p>Gelieve elke FK-kaart die uitgedeeld wordt hieronder te registreren
            en te koppelen aan een lid.</p>

        <p>Dit kan door middel van zijn stamnummer (nr. op
            de UGent kaart) of de barcode die ontvangen werd op het einde van
            het registratieproces</p>

        <dl class="form">
            <dt><?php echo form_label('Stamnummer:', 'ugent_nr'); ?></dt>
            <dd>
                <?php echo form_input('ugent_nr', set_value('ugent_nr')); ?>
                <?php echo form_error('ugent_nr'); ?>
            </dd>
            <dd class="input-seperator">of</dd>
            <dt><?php echo form_label('Barcode:', 'barcode'); ?></dt>
            <dd>
                <?php echo form_input('barcode', set_value('barcode')); ?>
                <?php echo form_error('barcode'); ?>
            </dd>
            <dt><?php echo form_label('Kaartnummer:', 'card_id'); ?></dt>
            <dd>
                <?php echo form_input('card_id', set_value('card_id')); ?>
                <?php echo form_error('card_id'); ?>
            </dd>
        </dl>

        <p>Optioneel kan je ook ISIC Plus kaarten verkopen. Deze worden op naam gedrukt
            en kunnen dus niet onmiddelijk meegegeven worden (geef dus wel een FK-kaart mee!).</p>

        <p>Deze kaart kost 3 euro en dient direct betaald te worden (dit kan anders geregeld
            zijn binnen je kring).</p>

        <dl class="form">
            <dt><?php echo form_label('ISIC-kaart?', 'isic'); ?></dt>
            <dd>
                <?php echo form_checkbox(array('name' => 'isic', 'id' => 'isic'), '1', set_value('isic') == 1); ?>
                <?php echo form_error('isic'); ?>
            </dd>
        </dl>

        <p><?php echo form_submit('submit', 'Uitvoeren!'); ?></p>

        <?php echo form_close(); ?>

    </div>
</div>

<style type="text/css">
dd.input-seperator {
    clear: both;
    float: none;
    margin-left: 120px;
    font-weight: bold;
    position: relative;
    top: -3px;
    text-align: center;
    width: 150px;
}
</style>