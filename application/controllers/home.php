<?php

class Home extends MY_Controller {
	public function index() {
        $kringen = new Kring();
        $kringen->order_by('lang')->get_by_gui_enabled();

        $this->template->set('pageTitle', 'Home');
        $this->template->load('layout', 'welcome', array('kringen' => $kringen->all));
	}

    public function login() {
        $this->load->library('phpCAS');

        if(!phpCAS::isAuthenticated()) {
            phpCAS::forceAuthentication();
        } else {
            redirect($this->input->get('return'));
        }
    }

    public function logout() {
        $this->load->library('phpCAS');
        phpCAS::logout();
    }
}
