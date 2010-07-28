<?php

class Home extends MY_Controller {
	public function index() {
        $kringen = new Kring();
        $kringen->order_by('lang')->get_by_gui_enabled();

        $this->template->set('pageTitle', 'Home');
        $this->template->load('layout', 'welcome', array('kringen' => $kringen->all));
	}

    public function login() {
        $this->load->library(array('phpCAS', 'session'));

        if(!phpCAS::isAuthenticated()) {
            $this->session->set_userdata('redirect_uri', $_SERVER['HTTP_REFERER']);
            phpCAS::forceAuthentication();
        } else {
            redirect($this->session->userdata('redirect_uri'));
        }
    }

    public function logout() {
        $this->load->library('phpCAS');
        phpCAS::logout();
    }
}
