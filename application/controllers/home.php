<?php

class Home extends MY_Controller {
	public function index() {
        $this->output->cache(3600);
        $kringen = new Kring();
        $kringen->order_by('lang')->get_by_gui_enabled();

        $this->template->set('pageTitle', 'Home');
        $this->template->load('layout', 'welcome', array('kringen' => $kringen->all));
	}

    public function logout() {
        $this->load->library('phpCAS');
        phpCAS::logout();
    }
}
