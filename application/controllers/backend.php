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
            $this->template->set('pageTitle', 'Instellingen &ndash; Backend');
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

    public function leden() {
        $this->determine_kring();
        $this->template->set('pageTitle', 'Leden &ndash; Backend');
        
        $action = $this->input->get('action');
        if(!$action || !in_array($action, array('browse', 'import', 'export'))) {
            $action = 'browse';
        }

        $members = new Member();
        $members->order_by('last_name ASC, first_name ASC')->get_by_kring_id($this->kring->id);

        $this->load->library('table');
        $this->table->set_heading(array('Naam', 'Voornaam', 'UGent nr.', 'FK nr.', 'Geregistreerd op'));
        $tmpl = array ( 'table_open'  => '<table border="1" cellpadding="2" cellspacing="1" class="mytable">' );

        $this->table->set_template(array(
            'table_open' => '<table cellspacing="0" class="datagrid">',
            'row_start' => '<tr class="rowOdd">',
            'row_alt_start' => '<tr class="rowEven">'
        ));

        foreach($members->all as $member) {
            $this->table->add_row(array($member->last_name, $member->first_name,
                    $member->ugent_nr, '&#8709;', $member->date_registered));
        }

        $this->template->load('layout', 'backend/leden', array(
            'kring' => $this->kring,
            'table' => $this->table
        ));
    }

    public function kaarten() {
        $this->determine_kring();
        $this->template->set('pageTitle', 'Leden &ndash; Kaarten toewijzen');

        $this->form_validation->set_rules('ugent_nr', 'Stamnummer', 'is_natural');
        $this->form_validation->set_rules('barcode', 'Barcode',
                'is_natural|trim|exact_length[13]|callback_barcode_or_ugent_nr');
        $this->form_validation->set_rules('card_id', 'Kaartnummer', 'required|is_natural');
        $this->form_validation->set_rules('isic', 'ISIC-kaart', '');


        $valid = $this->form_validation->run();
        if($valid) {
            // validate member
            $member = new Member();
            $member->where('kring_id', $this->kring->id);
            if(!empty($_POST['ugent_nr'])) {
                $member->get_by_ugent_nr($_POST['ugent_nr']);
            } else {
                $member->get_by_barcode_nr($_POST['barcode']);
            }

            if(count($member->all) == 0) {
                $this->form_validation->_field_data['barcode']['error'] = 'De ingegeven code is niet geldig.';
                $valid = false;
            }
        }

        if($valid) {
            // @TODO: check if a card was already associated

            $member->log($member->id, 'web', 'associated card #' . $_POST['card_id']);
            $card = new AssociatedCard();
            $card->member_id = $member->id;
            $card->card_id = $_POST['card_id'];
            $card->academic_year = $this->config->item('academic_year');
            $card->status = $_POST['isic'] != 1 ? 'payed' : 'payed+isic';
            $card->validate($this->kring->id);
            $card->save();

            // @TODO: show notice
        }

        $this->form_validation->set_error_delimiters('<div class="error">', '</div>');
        $this->template->load('layout', 'backend/kaarten', array(
            'kring' => $this->kring
        ));
    }

    public function barcode_or_ugent_nr($field, $param) {
        $field = $this->form_validation->set_value('barcode');
        $param = $this->form_validation->set_value('ugent_nr');
        return !empty($field) || !empty($param);
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
