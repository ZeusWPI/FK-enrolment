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

    public function instellingen() {
        $this->determine_kring();

        $this->load->helper(array('form', 'url'));
        $this->load->library('form_validation');

        $settings = new KringSetting();
        $settings->get_by_kring_id($this->kring->id);
        
        // create a new record if necessary
        if($settings->kring_id != $this->kring->id) {
            $settings->kring_id = $this->kring_id;
        }

        $this->form_validation->set_rules('enable_gui', 'Website actief?', 'is_natural');
        $this->form_validation->set_rules('enable_api', 'API actief?', 'is_natural');
        $this->form_validation->set_rules('api_key', 'API-sleutel', 'required|exact_length[12]');

        if($this->form_validation->run() == false) {
            $this->template->set('pageTitle', 'Backend');
            $this->template->load('layout', 'backend/instellingen', array(
                'kring' => $this->kring,
                'settings' => $settings
            ));
        } else {
            $settings->enable_gui = (int)$this->input->post('enable_gui');
            $settings->enable_api = (int)$this->input->post('enable_api');
            $settings->api_key = $this->input->post('api_key');
            $settings->save();
            redirect('/backend');
            // @TODO display succes message
        }
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
