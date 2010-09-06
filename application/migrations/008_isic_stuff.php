<?php

$this->load->helper('dbutil');

class Isic_stuff {
	function up() {
        $CI =& get_instance();
        $CI->load->database();

        echo "Adding column 'isic'", "<br />";
        $CI->db->query("ALTER TABLE `kringen_settings` ADD `isic` ENUM('yes','optional','no')" .
                "NOT NULL DEFAULT  'no' AFTER `api_key`");

        echo "Adding column 'confirmation_text'", "<br />";
        $CI->db->query("ALTER TABLE `kringen_settings` ADD `confirmation_text` ".
                "TEXT NOT NULL AFTER `isic`");

        echo "Adding column 'isic_newsletter'", "<br />";
        $CI->db->query("ALTER TABLE `members` ADD `isic_newsletter` ENUM('true', 'false') ".
                "NULL DEFAULT 'false'");
    }

    function down() {
        echo "Dropping column 'isic'", "<br />";
        remove_column('kringen_settings', 'isic');

        echo "Dropping column 'confirmation_text'", "<br />";
        remove_column('kringen_settings', 'confirmation_text');

        echo "Dropping column 'isic_newsletter'", "<br />";
        remove_column('members', 'isic_newsletter');
    }
}
