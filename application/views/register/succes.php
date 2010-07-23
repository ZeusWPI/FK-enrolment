<h2>Registratie succesvol</h2>
<div class="cols">
    <p class="col col-2">
    <img src="http://www.fkgent.be/intranet/schild/k.<?php echo $kring->kringname; ?>/h.180/w.110"
             alt="<?php echo $kring->kort; ?>" class="image-center" />
    </p>
    <div class="col col-4 col-last">
       <img src="<?php echo site_url("/api/v1/barcode?member_id=".$member_id); ?>" />
    </div>
</div>

