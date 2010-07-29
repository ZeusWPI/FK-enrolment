<?php

$this->load->helper('dbutil');

class Payed_cards {
	function up() {
        $CI =& get_instance();
        $CI->load->database();

        echo "Adding column 'status'", "<br />";
        $CI->db->query("ALTER TABLE `associated_cards` ADD `status` ".
                "ENUM('unpayed','payed','payed+isic') DEFAULT 'unpayed' AFTER `academic_year`");
    }

    function down() {
        echo "Dropping column 'status'", "<br />";
        remove_column('associated_cards', 'status');
    }
}
