<h2>Welkom</h2>

<p>Kies de kring waarbij je je wil registreren.</p>

<?php $i = 0; ?>
<?php foreach($kringen as $kring) : ?>
    <?php if($i % 4 == 0) echo '<div class="cols">'; ?>
    <div class="kring <?php if($i % 4 == 3) echo 'col-last' ?>">
        <?php $kring_url = site_url('registratie?kring='.$kring->kringname); ?>
        <a href="<?php echo $kring_url; ?>">
            <img src="http://www.fkgent.be/intranet/schild/k.<?php echo $kring->kringname; ?>/h.100/w.100"
            alt="Logo <?php echo $kring->kort; ?>" class="image-center" />
        <p><?php echo $kring->lang; ?></p>
        </a>
    </div>
    <?php if($i % 4 == 3) echo '</div>' ?>
    <?php $i++; ?>
<?php endforeach; ?>
<?php if($i % 4 != 0) echo '</div>' ?>

<style type="text/css">
.kring {
    width: 122px;
    margin: 16px 20px 0 0;
    float: left;
}

.kring p {
    text-align: center;
    margin: 6px 0 0 0;
    color: #000;
}

.kring a:hover p { text-decoration: underline; }
</style>