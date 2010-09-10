<div class="cols">
    <p class="col col-2">
        <img src="http://www.fkgent.be/intranet/schild/k.<?php echo $kring->kringname; ?>/h.180/w.110"
             alt="<?php echo $kring->kort; ?>" class="image-center image-header-offset" />
    </p>
    <div class="col col-5 col-last">
        <h2>Backend &ndash; Kaarten toewijzen</h2>

        <p><?php echo anchor('backend', '&laquo; Terug naar het overzicht'); ?></p>

        <?php if(!empty($message)) : ?>
            <p class="notice"><?php echo $message; ?></p>
        <?php endif; ?>

        <?php echo form_open('backend/kaarten'); ?>

        <dl class="form">
            <dd><?php echo form_error('barcode'); ?>
                <?php echo form_error('ugent_nr'); ?></dd>
            <dt><?php echo form_label('Stamnummer:', 'ugent_nr'); ?></dt>
            <dd>
                <?php echo form_input('ugent_nr', set_value('ugent_nr')); ?>
            </dd>
            <dd class="input-seperator">of</dd>
            <dt><?php echo form_label('Barcode:', 'barcode'); ?></dt>
            <dd>
                <?php echo form_input('barcode', set_value('barcode')); ?>
            </dd>
        </dl>

        <p><?php echo form_submit('submit_1', 'Opzoeken'); ?></p>

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

dd.input-seperator {
    clear: both;
    float: none;
    padding: 10px 0 10px 200px;
    font-weight: bold;
    font-size: 175%;
}

p input {
    font-size: 150%;
    margin: 10px 0 10px 200px;
}

.form {
    position: relative;
}

.form dd { width: 200px; }
.form dt, .form input { font-size:200%; width: 200px; }

.notice {
    font-size: 150%;
    width: 400px;
    text-align: center;
    margin: 20px 0;
    color: green;
}
</style>