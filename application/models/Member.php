<?php

class Member extends DataMapper {

	public $has_one = array('kring');

	public $created_field = 'date_registered';
	public $updated_field = 'date_modified';

	public function __construct() {
		parent::DataMapper();
	}

	public function log($member, $method, $action) {
		$this->db->insert('members_log', array(
			'member_id' => $member,
			'method' => $method,
			'action' => $action,
			'date' => date('Y-m-d H:i:s'),
			'ip' => $_SERVER['REMOTE_ADDR']
		));
	}
}