<?php

$this->load->helper('dbutil');

class Extra_properties {
	function up() {
        $CI =& get_instance();
        $CI->load->database();

        echo "Adding column 'sex'", "<br />";
        $CI->db->query("ALTER TABLE `members` ADD `sex` ENUM('m', 'f') ".
                "NULL DEFAULT NULL AFTER `address_kot`");

        echo "Adding column 'date_of_birth'", "<br />";
        $CI->db->query("ALTER TABLE `members` ADD `date_of_birth` ".
                "DATETIME NULL DEFAULT NULL AFTER `sex`");
    }

    function down() {
        echo "Dropping column 'sex'", "<br />";
        remove_column('members', 'sex');

        echo "Dropping column 'date_of_birth'", "<br />";
        remove_column('members', 'date_of_birth');
    }
}
