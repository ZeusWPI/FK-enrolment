<div class="cols">
    <p class="col col-2">
        <img src="<?php echo site_url('assets/schilden/'.$kring->kringname.'.jpg'); ?>"
             alt="<?php echo $kring->kort; ?>" class="image-center image-header-offset" />
    </p>
    <div class="col col-5 col-last">
        <h2>Backend &ndash; Kaarten toewijzen</h2>

        <p><?php echo anchor('backend', '&laquo; Terug naar het overzicht'); ?></p>

         <?php if(!empty($message)) : ?>
            <p class="notice"><?php echo $message; ?></p>
        <?php endif; ?>

        <p>Klik op onderstaande knop om de informatie aan ISIC door te geven</p>
        <div id="d_clip_container" style="position:relative">
            <div id="d_clip_button">Kopiëren</div>
        </div>

        <p><?php echo anchor('backend/kaarten', 'Volgende registratie &raquo;'); ?></p>
    </div>
</div>

<script type="text/javascript" src="<?php echo site_url('assets/ZeroClipboard.js'); ?>"></script>
<script type="text/javascript"> 
    window.onload = function() {
	    ZeroClipboard.setMoviePath("<?php echo site_url('assets/ZeroClipboard.swf'); ?>");
    	var clip = new ZeroClipboard.Client();
    	clip.setText("<?php echo $isic; ?>");
    	clip.glue("d_clip_button", "d_clip_container");
   }
</script>
<style type="text/css">
.notice {
    font-size: 150%;
    width: 400px;
    text-align: center;
    margin: 20px 0;
    color: green;
}
#d_clip_container {
    width: 400px;
    position: relative;
    margin: 20px 0;
}
#d_clip_button {
    cursor: hand;
    width:150px;
    border:1px solid black;
    text-align: center;
    background-color:#ccc;
    margin:10px auto; padding:10px;
}
#d_clip_button.hover { background-color:#eee; }
#d_clip_button.active { background-color:#aaa; }
</style>