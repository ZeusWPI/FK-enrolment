<?php

class KringSetting extends DataMapper {
	public $table = 'kringen_settings';
	public $modified_field = 'date_modified';

    public function get_by_gui_enabled() {
        $this->where(array('actief' => 1, 'showonsite' => 1));
        $this->where_related_setting('gui_enabled', 1);

        return $this->get();
    }
}
