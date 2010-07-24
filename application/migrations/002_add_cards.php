<?php

$this->load->helper('dbutil');

class Add_cards {
    function up() {
        echo "Creating table 'associated_cards'", "<br />";
        create_table('associated_cards', array(
                'id' => array(INTEGER, NOT_NULL),
                'member_id' => array(INTEGER, NOT_NULL),
                'card_id' => array(INTEGER, NOT_NULL),
                'academic_year' => array(STRING, LIMIT, 10),
                'date_added' => array(DATETIME, NOT_NULL),
                'disabled' => array(BOOLEAN, NOT_NULL, DEFAULT_VALUE, false),
            ), 'id'
        );
    }

    function down() {
        echo "Dropping table 'associated_cards'", "<br />";
        drop_table('associated_cards');
    }
}
