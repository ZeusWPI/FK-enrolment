<?php

$this->load->helper('dbutil');

class Create_schema {
	function up() {
 		create_table(
			'members',
			array(
				'id' => array(INTEGER, NOT_NULL),
				'first_name' => array(STRING, LIMIT, 255, NOT_NULL),
				'last_name' => array(STRING, LIMIT, 255, NOT_NULL),
				'email' => array(STRING, LIMIT, 255),
				'ugent_nr' => INTEGER,
				'ugent_login' => array(STRING, LIMIT, 20),
				'cellphone' => array(STRING, LIMIT, 20),
				'address_home' => array(STRING, LIMIT, 255),
				'address_kot' => array(STRING, LIMIT, 255),
				'date_registered' => array(DATE, NOT_NULL),
				'date_modified' => array(DATE, NOT_NULL),
				'disabled' => array(BOOLEAN, NOT_NULL, DEFAULT_VALUE, false),
			),
			'id'
		);

		create_table(
			'members_log',
			array(
				'id' => array(INTEGER, NOT_NULL),
				'member_id' => array(INTEGER, NOT_NULL),
				'method' => array(STRING, LIMIT, 255),
				'action' => array(STRING, LIMIT, 255),
				'date' => array(DATE, NOT_NULL),
				'ip' => array(INTEGER, NOT_NULL),
			),
			'id'
		);
	}

	function down() {
		drop_table('members');
		drop_table('members_log');
	}
}
