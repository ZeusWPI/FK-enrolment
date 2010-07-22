<?php

class Registratie extends Controller {
    private $kring;

    public function index() {
        $this->determine_kring();

        $this->template->set('pageTitle', 'Registeren');
        $this->template->load('layout', 'register/start', array(
            'kring' => $this->kring
        ));
    }

    public function via_ugentnr() {
        $this->determine_kring();

        $this->load->helper(array('form', 'url'));
        $this->load->library('form_validation');

        $this->form_validation->set_rules('stamnummer','Stamnummer','required');
        $this->form_validation->set_rules('voornaam', 'Voornaam', 'required');
        $this->form_validation->set_rules('familienaam', 'Familienaam', 'required');
        $this->form_validation->set_rules('emailadres', 'Emailadres', 'valid_email');

        if($this->form_validation->run() == false){
            
            $this->template->set('pageTitle', 'Inschrijven met ugent nr');
            $this->template->load('layout', 'register/via-ugentnr', array(
                'kring' => $this->kring
            ));

        } else {
            $this->template->set('pageTitle', 'SUCCES BITCHES');
            $this->template->load('layout', 'register/via-ugentnr', array(
                'kring' => $this->kring
            ));

        }
    }

    private function determine_kring() {
        $this->kring = new Kring();

        $this->load->library('session');
        $kring_id = $this->session->userdata('kring_id');

        $kring_name = $this->input->get('kring');
        if(!empty($kring_name)) {
            $this->kring->get_where(array(
                'kringname' => $kring_name,
                'actief' => 1,
                'showonsite' => 1
            ));
            $this->session->set_userdata('kring_id', $this->kring->id);
        } else {
            $this->kring->get_by_id($kring_id);
        }

        if(count($this->kring->all) != 1) {
            show_404();
        }
    }
}
