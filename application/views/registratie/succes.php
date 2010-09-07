<div class="cols">
    <p class="col col-2">
    <img src="http://www.fkgent.be/intranet/schild/k.<?php echo $kring->kringname; ?>/h.180/w.110"
             alt="<?php echo $kring->kort; ?>" class="image-center image-header-offset" />
    </p>
    <div class="col col-5 col-last">
        <h2>Inschrijving succesvol</h2>

        <?php
        $barcode = '<p><img src=' .  site_url("/api/v1/barcode?member_id=".$member_id) . '
                alt="Barcode" id="barcode" /></p>';
        echo str_replace('[barcode]', $barcode, nl2br($settings->confirmation_text));
        ?>

        <p><button onClick="window.print()" class="no-print">Print deze pagina</button></p>
    </div>
</div>

<!-- Sneaky way to perform CAS logout when finished -->
<iframe src="<?php echo site_url('/home/logout'); ?>" style="display: none;"></iframe>

<style type="text/css">
#barcode {
    padding: 20px;
}
</style>