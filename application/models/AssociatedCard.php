<?php

class AssociatedCard extends DataMapper {

    public $table = 'associated_cards';
	public $created_field = 'date_added';

	public $validation = array(
		array('field' => 'member_id', 'label' => 'member id',
			'rules' => array('required', 'is_natural', 'exists' => 'kringen')),
		array('field' => 'card_id', 'label' => 'card id',
			'rules' => array('required', 'is_natural'))
	);

	public function __construct() {
		parent::DataMapper();
	}

    public function validate($kring_id) {
        if($this->validated) {
            return $this;
        }
        
        parent::validate();

        if(!$this->valid) return $this;

        // perform additional validation
        $member = new Member();
        $member->get_by_id($this->member_id);

        if($member->count() != 1 || $member->kring_id != $kring_id) {
            $error = $this->lang->line('invalid_access_for_kring');
            $this->error_message('member_id', sprintf($error, 'member id'));
            $this->valid = false;
        }
        
        return $this;
    }

    /**
     * Validator function to check if a reffered id exists
     */
	public function _exists($field, $table = '') {
		$record = $this->db->from($table)->where('id', $this->{$field});
		return $record->count_all_results() == 1;
	}
}