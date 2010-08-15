<?php

$this->load->helper('dbutil');

class Isic_field {
	function up() {
        $CI =& get_instance();
        $CI->load->database();

        echo "Adding column 'isic'", "<br />";
        $CI->db->query("ALTER TABLE `members` ADD `isic` ENUM('true', 'false') ".
                "NULL DEFAULT NULL");
    }

    function down() {
        echo "Dropping column 'isic'", "<br />";
        remove_column('members', 'isic');
    }
}
