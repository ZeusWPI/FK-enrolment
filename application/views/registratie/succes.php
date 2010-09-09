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
        if(empty($settings->confirmation_text)) :
        ?>
        <p>
            Je inschrijving is goed ontvangen. De volgende stap
            is je te begeven naar de boekenverkoop/permanentie van je kring en
            je lidgeld te betalen. Wanneer dit gebeurd is zal de inschrijving voltooid zijn.
        </p><p>
            Voor meer informatie over de datum van boekenverkopen/permanenties
            en de prijzen van het lidgeld verwijzen we graag naar de website van je kring.
        </p><p>
            Wanneer je je naar de boekenverkoop begeeft vergeet dan zeker niet
            je <strong>UGent- studentenkaart</strong>. Heb je deze nog niet,
            gebruik dan onderstaande <strong>barcode</strong>.
        </p>
        <?php echo $barcode; ?>
        <?php else :
            echo str_replace('[barcode]', $barcode, $settings->confirmation_text);
        endif; ?>

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