<div class="cols">
    <p class="col col-2">
        <img src="http://www.fkgent.be/intranet/schild/k.<?php echo $kring->kringname; ?>/h.180/w.110"
             alt="<?php echo $kring->kort; ?>" class="image-center image-header-offset" />
    </p>
    <div class="col col-5 col-last">
        <h2>Backend &ndash; Kaarten toewijzen</h2>

        <p><?php echo anchor('backend', '&laquo; Terug naar het overzicht'); ?></p>

        <?php echo form_open('backend/kaarten'); ?>
        <?php echo form_hidden('member_id', $memberId); ?>
        <dl class="form">
            <dd><?php echo form_error('card_id'); ?></dd>
            <dt>Naam:</dt>
            <dd><span><?php echo $firstName, ' ', $lastName; ?></span></dd>
            <dt><?php echo form_label('Kaartnummer:', 'card_id'); ?></dt>
            <dd>
                <?php echo form_input('card_id', set_value('card_id')); ?>
            </dd>
        </dl>

        <p>Optioneel kan je ook ISIC Plus kaarten verkopen. Deze worden op naam gedrukt
            en kunnen dus niet onmiddelijk meegegeven worden (geef dus wel een FK-kaart mee!).</p>

        <p>Deze kaart kost 3 euro en dient direct betaald te worden (dit kan anders geregeld
            zijn binnen je kring).</p>

        <dl class="form">
            <dt><?php echo form_label('ISIC-kaart?', 'isic'); ?></dt>
            <dd>
                <?php echo form_checkbox(array('name' => 'isic', 'id' => 'isic'), '1', $wantsIsic); ?>
                <?php echo form_error('isic'); ?>
            </dd>
        </dl>

        <p><?php echo form_submit('submit_2', 'Kaart koppelen'); ?></p>

        <?php echo form_close(); ?>

    </div>
</div>

<style type="text/css">
.error {
    font-size: 150%;
    width: 400px;
    text-align: center;
    margin-bottom: 10px;
}

p input {
    font-size: 150%;
    margin: 10px 0 10px 200px;
}

.form {
    position: relative;
}

.form dd { width: 200px; }
.form dt, .form input, .form dd span { font-size:200%; width: 200px; }
</style>