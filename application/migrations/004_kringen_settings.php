<?php

$this->load->helper('dbutil');

class Kringen_settings {
	function up() {
        echo "Creating table 'kringen_settings'", "<br />";
        create_table('kringen_settings', array(
            'id' => array(INTEGER, NOT_NULL),
            'kring_id' => array(INTEGER, NOT_NULL),
            'enable_gui' => array(BOOLEAN, NOT_NULL, DEFAULT_VALUE, 0),
            'enable_api' => array(BOOLEAN, NOT_NULL, DEFAULT_VALUE, 0),
            'api_key' => array(STRING, LIMIT, 255),
            'date_modified' => array(DATETIME, NOT_NULL),
        ), 'id');

        echo "Generating API keys", "<br />";
        $kringen = new Kring();
        $kringen->get();
        foreach($kringen->all as $kring) {
            $settings = new KringSetting();
            $settings->kring_id = $kring->id;
            $settings->enable_gui = 0;
            $settings->enable_api = 1;
            $settings->api_key = generate_api_key($kring->id);
            $settings->save();
        }
    }

    function down() {
        echo "Dropping table 'kringen_settings'", "<br />";
        drop_table('kringen_settings');
    }
}
