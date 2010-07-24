<?php

class Kring extends DataMapper {
	public $table = 'kringen';

    public function get_by_gui_enabled() {
        // get all kringen with active gui
        $kringen = $this->db->query('SELECT kring_id FROM kringen_settings WHERE enable_gui = 1')->row_array();
        array_walk($kringen, create_function('$a', 'return $a[\'kring_id\'];'));

        $this->where(array('actief' => 1, 'showonsite' => 1));
        $this->where_in('id', $kringen);

        return $this->get();
    }
}
