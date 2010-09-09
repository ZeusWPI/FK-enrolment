<?php

$this->load->helper('dbutil');

class Isic_stuff {
	function up() {
        $CI =& get_instance();
        $CI->load->database();

        echo "Adding column 'isic'", "<br />";
        $CI->db->query("ALTER TABLE `kringen_settings` ADD `isic` ENUM('yes','optional','no')" .
                "NOT NULL DEFAULT  'no' AFTER `api_key`");

        echo "Adding column 'isic_text'", "<br />";
        $CI->db->query("ALTER TABLE `kringen_settings` ADD `isic_text` ".
                "TEXT NOT NULL AFTER `isic`");

        echo "Adding column 'confirmation_text'", "<br />";
        $CI->db->query("ALTER TABLE `kringen_settings` ADD `confirmation_text` ".
                "TEXT NOT NULL AFTER `isic_text`");

        $CI->db->query("UPDATE kringen_settings SET confirmation_text = '". <<<EOT
<p>Je inschrijving is goed ontvangen. De volgende stap is je te begeven naar de boekenverkoop/permanentie van je kring en je lidgeld te betalen. Wanneer dit gebeurd is zal de inschrijving voltooid zijn.</p>

<p>Voor meer informatie over de datum van boekenverkopen/permanenties en de prijzen van het lidgeld verwijzen we graag naar de website van je kring.</p>

<p>Wanneer je je naar de boekenverkoop begeeft vergeet dan zeker niet je <strong>UGent- studentenkaart</strong>. Heb je deze nog niet, gebruik dan onderstaande <strong>barcode</strong>.</p>

[barcode]
EOT
                ."'");

        echo "Adding column 'isic_newsletter'", "<br />";
        $CI->db->query("ALTER TABLE `members` ADD `isic_newsletter` ENUM('true', 'false') ".
                "NOT NULL DEFAULT 'false'");
    }

    function down() {
        echo "Dropping column 'isic'", "<br />";
        remove_column('kringen_settings', 'isic');

        echo "Dropping column 'isic_text'", "<br />";
        remove_column('kringen_settings', 'isic_text');

        echo "Dropping column 'confirmation_text'", "<br />";
        remove_column('kringen_settings', 'confirmation_text');

        echo "Dropping column 'isic_newsletter'", "<br />";
        remove_column('members', 'isic_newsletter');
    }
}
