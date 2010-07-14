<?php

$this->load->helper('dbutil');

class Create_schema {
	function up() {
 		create_table('members', array(
				'id' => array(INTEGER, NOT_NULL),
				'kring_id' => array(INTEGER, NOT_NULL),
				'first_name' => array(STRING, LIMIT, 255, NOT_NULL),
				'last_name' => array(STRING, LIMIT, 255, NOT_NULL),
				'email' => array(STRING, LIMIT, 255),
				'ugent_nr' => INTEGER,
				'ugent_login' => array(STRING, LIMIT, 20),
				'cellphone' => array(STRING, LIMIT, 20),
				'address_home' => array(STRING, LIMIT, 255),
				'address_kot' => array(STRING, LIMIT, 255),
				'date_registered' => array(DATETIME, NOT_NULL),
				'date_modified' => array(DATETIME, NOT_NULL),
				'disabled' => array(BOOLEAN, NOT_NULL, DEFAULT_VALUE, false),
			), 'id'
		);

		create_table('members_log', array(
				'id' => array(INTEGER, NOT_NULL),
				'member_id' => array(INTEGER, NOT_NULL),
				'method' => array(STRING, LIMIT, 255),
				'action' => array(STRING, LIMIT, 255),
				'date' => array(DATETIME, NOT_NULL),
				'ip' => array(STRING, LIMIT, 15, NOT_NULL),
			), 'id'
		);

		// based on original schema
		create_table('kringen', array(
				'id' => array(INTEGER, NOT_NULL),
				'kort' => array(STRING, NOT_NULL, LIMIT, 20),
				'lang' => array(STRING, NOT_NULL, LIMIT, 255),
				'url' => array(STRING, NOT_NULL, LIMIT, 255),
				'email' => array(STRING, NOT_NULL, LIMIT, 255),
				'tel' => array(STRING, NOT_NULL, LIMIT, 20, DEFAULT_VALUE, ''),
				'fax' => array(STRING, NOT_NULL, LIMIT, 20, DEFAULT_VALUE, ''),
				'adres' => array(STRING, NOT_NULL, LIMIT, 255),
				'kleuren' => array(STRING, NOT_NULL, LIMIT, 255),
				'stichting' => array(INTEGER, NOT_NULL, LIMIT, 4),
				'stichter' => array(STRING, NOT_NULL, LIMIT, 255),
				'kleuren' => array(STRING, NOT_NULL, LIMIT, 255),
				'descr' => array(TEXT, NOT_NULL),
				'FKlogin' => array(STRING, NOT_NULL, LIMIT, 25, DEFAULT_VALUE, ''),
				'DSAlogin' => array(STRING, NOT_NULL, LIMIT, 25, DEFAULT_VALUE, ''),
				'kringname' => array(STRING, NOT_NULL, LIMIT, 20),
				'actief' => array(BOOLEAN, NOT_NULL, DEFAULT_VALUE, 1),
				'showonsite' => array(BOOLEAN, NOT_NULL, DEFAULT_VALUE, 1)
			), 'id'
		);
		add_index('kringen', 'FKlogin', 'FKlogin', 'UNIQUE');
	}

	function down() {
		drop_table('members');
		drop_table('members_log');
		drop_table('kringen');
	}
}
