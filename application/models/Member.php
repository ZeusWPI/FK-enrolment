<?php

class Member extends DataMapper {

	public $has_one = array('kring');

	public $created_field = 'date_registered';
	public $updated_field = 'date_modified';

	public $validation = array(
		array('field' => 'kring_id', 'label' => 'kring',
			'rules' => array('required', 'is_natural', 'exists' => 'kringen')),
		array('field' => 'first_name', 'label' => 'first name',
			'rules' => array('required')),
		array('field' => 'last_name', 'label' => 'last name',
			'rules' => array('required')),
		array('field' => 'email', 'label' => 'e-mail address',
			'rules' => array('valid_email')),
		array('field' => 'ugent_nr', 'label' => 'UGent nr.',
			'rules' => array('is_natural_no_zero'))
	);

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

	public function _require_one_of_two($field, $param= '') {
		return !empty($this->email) || !empty($this->ugent_nr);
	}

	public function _exists($field, $table = '') {
		$record = $this->db->from($table)->where('id', $this->{$field});
		return $record->count_all_results() == 1;
	}
}