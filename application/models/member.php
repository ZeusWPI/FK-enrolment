<?php

class Member extends DataMapper {

	public $has_one = array('kring', 'associatedcard');

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
			'rules' => array('not_required_if' => 'ugent_nr', 'valid_email')),
		array('field' => 'ugent_nr', 'label' => 'UGent nr.',
			'rules' => array('not_required_if' => 'email', 'is_natural'))
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

	public function _not_required_if($field, $param= '') {
		return !empty($this->{$field}) || !empty($this->{$param});
    }

    /**
     * Validator function to check if a reffered id exists
     */
	public function _exists($field, $table = '') {
		$record = $this->db->from($table)->where('id', $this->{$field});
		return $record->count_all_results() == 1;
	}
}
