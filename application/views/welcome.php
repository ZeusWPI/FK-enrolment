<h2>Welkom</h2>

<p>Kies de kring waarbij je je wil registreren.</p>

<?php foreach($kringen as $kring) : ?>
<div class="kring">
    <?php $kring_url = site_url('registratie?kring='.$kring->kringname); ?>
    <a href="<?php echo $kring_url; ?>">
        <img src="http://www.fkgent.be/intranet/schild/k.<?php echo $kring->kringname; ?>/h.100/w.100"
        alt="<?php echo $kring->kort; ?>" class="image-center" />
    <p><?php echo $kring->kort; ?></p>
    </a>
</div>
<?php endforeach; ?>

<style type="text/css">
.kring {
    width: 112px; height: 125px;
    margin: 16px 24px 0 0;
    float: left;
    position: relative;
}

.kring p {
    text-align: center;
    position: absolute;
    bottom: 0;
    width: 100%;
    margin: 0;
}

.kring a {
    color: #000;
}
</style>