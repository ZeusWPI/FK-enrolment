<div class="cols">
    <p class="col col-2">
        <img src="<?php echo site_url('assets/schilden/'.$kring->kringname.'.jpg'); ?>"
             alt="<?php echo $kring->kort; ?>" class="image-center image-header-offset" />
    </p>
    <div class="col col-5 col-last">
        <h2>Backend</h2>

        <p>Welkom op de FK-enrolment backend voor <?php echo $kring->lang; ?>. U heeft nu toegang tot:</p>

        <ul>
            <li><?php echo anchor('/backend/instellingen', 'Kringinstellingen'); ?></li>
            <li><?php echo anchor('/backend/leden', 'Ledenbeheer'); ?>: import, export, &hellip;</li>
            <li><?php echo anchor('/backend/kaarten', 'Kaarten toewijzen'); ?></li>
        </ul>
    </div>
</div>