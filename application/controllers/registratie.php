<?php

class Registratie extends MY_Controller {
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

        $this->form_validation->set_rules('ugent_nr','Stamnummer','required');
        $this->form_validation->set_rules('first_name', 'Voornaam', 'required');
        $this->form_validation->set_rules('last_name', 'Familienaam', 'required');
        $this->form_validation->set_rules('email', 'Emailadres', 'valid_email');

        if($this->form_validation->run() == false){
            
            $this->template->set('pageTitle', 'Inschrijven met ugent nr');
            $this->template->load('layout', 'register/via-ugentnr', array(
                'kring' => $this->kring
            ));

        } else {
            $member = new Member();
            $member->kring_id = $this->kring->id;
            $member->first_name = $this->input->post('first_name');
            $member->last_name = $this->input->post('last_name');
            $member->email = $this->input->post('email');
            $member->ugent_nr = $this->input->post('ugent_nr');
            $member->ugent_login = $this->input->post('ugent_login');
            $member->cellphone = $this->input->post('cellphone');
            $member->address_home = $this->input->post('address_home');
            $member->address_kot = $this->input->post('address_kot');

            if($member->validate()->valid) {
                $member->save();
                $this->template->set('pageTitle', 'Inschrijving succesvol');
                $this->template->load('layout', 'register/succes', array(
                    'kring' => $this->kring,
                    'member' => $this->member
                ));
            } else {
            
            }
 
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
