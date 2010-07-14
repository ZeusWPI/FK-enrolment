<?php

class Kring extends DataMapper {

	public $has_many = array('Member');
	public $table = 'kringen';

	public function __construct() {
		parent::DataMapper();
	}
}