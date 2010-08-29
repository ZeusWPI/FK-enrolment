<?php

$this->load->helper('dbutil');

class Sessions {
	function up() {
        $CI =& get_instance();
        $CI->load->database();

        echo "Creatintg table 'sessions'", "<br />";
        $CI->db->query("CREATE TABLE IF NOT EXISTS  `sessions` (
session_id varchar(40) DEFAULT '0' NOT NULL,
ip_address varchar(16) DEFAULT '0' NOT NULL,
user_agent varchar(50) NOT NULL,
last_activity int(10) unsigned DEFAULT 0 NOT NULL,
user_data text NOT NULL,
PRIMARY KEY (session_id)
);");
    }

    function down() {
        echo "Dropping table 'sessions'", "<br />";
        drop_table('sessions');
    }
}
