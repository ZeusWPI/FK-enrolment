<?php

class Kring extends DataMapper {

	public $has_many = array('member');
	public $table = 'kringen';

	public function __construct() {
		parent::DataMapper();
	}
}