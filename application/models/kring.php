<?php

class Kring extends DataMapper {
	public $table = 'kringen';

    public function get_by_gui_enabled() {
        // get all kringen with active gui
        $kringen = $this->db->query('SELECT kring_id FROM kringen_settings WHERE enable_gui = 1')->result_array();
        $kringen = array_map(create_function('$a', 'return $a[\'kring_id\'];'), $kringen);
        if(count($kringen) == 0) $kringen = array(0);

        $this->where(array('actief' => 1, 'showonsite' => 1));
        $this->where_in('id', $kringen);

        return $this->get();
    }

    public function is_gui_enabled() {
        $result = $this->db->query('SELECT enable_gui FROM kringen_settings
            WHERE kring_id = ?', array($this->id))->row_array();
        return !empty($result) && $result['enable_gui'] == 1;
    }
}
