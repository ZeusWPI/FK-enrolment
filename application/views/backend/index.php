<h2>Backend</h2>

<div class="cols">
    <p class="col col-2">
        <img src="http://www.fkgent.be/intranet/schild/k.<?php echo $kring->kringname; ?>/h.180/w.110"
             alt="<?php echo $kring->kort; ?>" class="image-center" />
    </p>
    <div class="col col-4 col-last">
        <p>Welkom op de FK-enrolment backend voor <?php echo $kring->lang; ?>. U heeft nu toegang tot:</p>

        <ul>
            <li><?php echo anchor('/backend/settings', 'Kringinstellingen'); ?></li>
            <li><?php echo anchor('/backend/members', 'Ledenbheer'); ?>: import, export, &hellip;</li>
        </ul>
    </div>
</div>