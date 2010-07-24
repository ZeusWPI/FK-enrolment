<?php

class Backend extends MY_Controller {
    private $kring;

    public function index() {
        $this->determine_kring();

        $this->template->set('pageTitle', 'Backend');
        $this->template->load('layout', 'backend/index', array(
            'kring' => $this->kring
        ));
    }
    
    public function aanmelden() {
        // @TODO perform real authentication
        if($this->input->post('submit')) {
            $this->load->library('session');
            $this->session->set_userdata('backend_kring_id', 28);
            redirect('/backend');
        }

        $this->template->set('pageTitle', 'Aanmelden &ndash; Backend');
        $this->template->load('layout', 'backend/aanmelden');
    }

    private function determine_kring() {
        // @TODO perform authentication here
        $this->kring = new Kring();

        $this->load->library('session');
        $kring_id = $this->session->userdata('backend_kring_id');
        $this->kring->get_by_id($kring_id);

        if(count($this->kring->all) != 1) {
            redirect('/backend/aanmelden');
        }
    }
}
