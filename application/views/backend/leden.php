<h2>Backend &raquo; leden</h2>

<p style="float: left;"><?php echo anchor('/backend', '&laquo; Terug naar het overzicht'); ?></p>

<p style="float: right;"><?php echo anchor('/backend/export', 'Exporteer gegevens &raquo;'); ?></p>

<h3 style="clear: both;">Laatste 100 geregistreerde leden</h3>

<?php echo $table->generate(); ?>