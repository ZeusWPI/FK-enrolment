<?php

class Registratie extends MY_Controller {
    private $kring;
    private $settings;

    public function index() {
        $this->determine_kring();

        $this->template->set('pageTitle', 'Registeren');
        $this->template->load('layout', 'registratie/index', array(
            'kring' => $this->kring
        ));
    }

    public function via_cas() {
        $this->load->library('phpCAS');
        phpCAS::forceAuthentication();

        $this->determine_kring();

        $attributes = phpCAS::getAttributes();
        $_POST['ugent_nr'] = $attributes['ugentStudentID'];
        $_POST['first_name'] = $attributes['givenname'];
        $_POST['last_name'] = $attributes['surname'];
        $_POST['email'] = $attributes['mail'];

        if(!$this->validate_form()) {
            $this->template->set('pageTitle', 'Inschrijven via CAS');
            $this->template->load('layout', 'registratie/form', array(
                'method' => 'CAS',
                'kring' => $this->kring
            ));
        } else {
            redirect('/registratie/isic');
        }
    }

    public function via_ugentnr() {
        $this->determine_kring();

        if(!$this->validate_form()) {
            $this->template->set('pageTitle', 'Inschrijven via stamnummer');
            $this->template->load('layout', 'registratie/form', array(
                'method' => 'stamnummer',
                'kring' => $this->kring
            ));
        } else {
            redirect('/registratie/isic');
        }
    }

    public function via_mail() {
        $this->determine_kring();

        if(!$this->validate_mail()) {
            $this->template->set('pageTitle', 'Inschrijven zonder UGent gegevens');
            $this->template->load('layout', 'registratie/form', array(
                'method' => 'mail',
                'kring' => $this->kring
            ));
        } else {
            redirect('/registratie/isic');
        }
    }

    private function validate_mail() {
        $this->load->helper(array('form', 'url', 'date'));
        $this->load->library(array('form_validation', 'session'));

        $this->form_validation->set_rules('submit', '', 'required');
        $this->form_validation->set_rules('first_name', 'Voornaam', 'required');
        $this->form_validation->set_rules('last_name', 'Familienaam', 'required');
        $this->form_validation->set_rules('email', 'Emailadres', 'required|valid_email');
        $this->form_validation->set_rules('cellphone', 'Telefoonnummer', '');
        $this->form_validation->set_rules('address_home', 'Thuisadres', '');
        $this->form_validation->set_rules('address_kot', 'kotadres', '');
        $this->form_validation->set_rules('sex', 'Geslacht', 'callback_in_array[m,f]');
        $this->form_validation->set_rules('year_of_birth', 'Geboortejaar', 'is_natural');
        $this->form_validation->set_rules('month_of_birth', 'Geboortemaand', 'is_natural');
        $this->form_validation->set_rules('day_of_birth', 'Geboortedag', 'is_natural');

        if($this->form_validation->run() == true) {
            $member = new Member();
            $member->kring_id = $this->kring->id;
            $member->first_name = $this->input->post('first_name');
            $member->last_name = $this->input->post('last_name');
            $member->email = $this->input->post('email');

            $member->cellphone = $this->input->post('cellphone');
            $member->address_home = $this->input->post('address_home');
            $member->address_kot = $this->input->post('address_kot');
            $member->sex = $this->input->post('sex');

            $timestamp = mktime(0, 0, 0, (int)$this->input->post('day_of_birth'),
                                         (int)$this->input->post('month_of_birth'),
                                         (int)$this->input->post('year_of_birth'));
            $member->date_of_birth = strftime('%Y', $timestamp);

            $member->save();
            $this->session->set_userdata('member_id', $member->id);
            return true;
        } else {
            $this->form_validation->set_error_delimiters('<div class="error">', '</div>');
            return false;
        }
    }

    private function validate_form() {
        $this->load->helper(array('form', 'url', 'date'));
        $this->load->library(array('form_validation', 'session'));

        $this->form_validation->set_rules('submit', '', 'required');
        $this->form_validation->set_rules('ugent_nr','Stamnummer', 'required|is_natural');
        $this->form_validation->set_rules('first_name', 'Voornaam', 'required');
        $this->form_validation->set_rules('last_name', 'Familienaam', 'required');
        $this->form_validation->set_rules('email', 'Emailadres', 'required|valid_email');
        $this->form_validation->set_rules('cellphone', 'Telefoonnummer', '');
        $this->form_validation->set_rules('address_home', 'Thuisadres', '');
        $this->form_validation->set_rules('address_kot', 'kotadres', '');
        $this->form_validation->set_rules('sex', 'Geslacht', 'callback_in_array[m,f]');
        $this->form_validation->set_rules('year_of_birth', 'Geboortejaar', 'is_natural');
        $this->form_validation->set_rules('month_of_birth', 'Geboortemaand', 'is_natural');
        $this->form_validation->set_rules('day_of_birth', 'Geboortedag', 'is_natural');

        if($this->form_validation->run() == true) {
            $member = new Member();
            $member->kring_id = $this->kring->id;
            $member->ugent_nr = $this->input->post('ugent_nr');
            $member->first_name = $this->input->post('first_name');
            $member->last_name = $this->input->post('last_name');
            $member->email = $this->input->post('email');

            $member->cellphone = $this->input->post('cellphone');
            $member->address_home = $this->input->post('address_home');
            $member->address_kot = $this->input->post('address_kot');
            $member->sex = $this->input->post('sex');

            $timestamp = mktime(0, 0, 0, (int)$this->input->post('day_of_birth'),
                                         (int)$this->input->post('month_of_birth'),
                                         (int)$this->input->post('year_of_birth'));
            $member->date_of_birth = strftime('%F', $timestamp);

            $member->save();
            $this->session->set_userdata('member_id', $member->id);
            return true;
        } else {
            $this->form_validation->set_error_delimiters('<div class="error">', '</div>');
            return false;
        }
    }

    public function isic() {
        $this->determine_kring();

        if($this->settings->isic == 'no') {
            return redirect('registratie/succes');
        }
        
        if(!$this->validate_isic()) {
            $this->template->set('pageTitle', 'Registratie ISIC kaart');
            $this->template->load('layout', 'registratie/isic', array(
                'kring' => $this->kring,
                'settings' => $this->settings,
                'allow_choice' => ($this->settings->isic == 'maybe'),
            ));
        } else {
            redirect('registratie/succes');
        }
    }

    private function validate_isic() {
        /* Get member by id */
        $member_id = $this->session->userdata('member_id');
        $member = new Member();
        $member->get_by_id($member_id);

        /* Store isic data */
        if(count($member->all) > 0) {
            if(count($_POST) == 0) return false;

            $alwaysTrue = ($this->settings->isic == 'yes');
            if(isset($_POST['isic_true']) || $alwaysTrue) {
                $member->isic = 'true';
            } else {
                $member->isic = 'false';
            }

            $member->isic_newsletter = isset($_POST['isic_newsletter']) ? 'true' : 'false';
            $member->save();
            return true;
        }

        return false;
    }

    public function succes() {
        $this->load->library('session');
        $this->determine_kring();

        $member_id = $this->session->userdata('member_id');
        $this->template->set('pageTitle', 'Inschrijving succesvol');
        $this->template->load('layout', 'registratie/succes', array(
            'kring' => $this->kring,
            'settings' => $this->settings,
            'member_id' => Member::generate_barcode_nr($member_id)
        ));
    }

    public function in_array($value, $range) {
        $range = explode(',', $range);
        return in_array($value, $range);
    }

    private function determine_kring() {
        $this->load->library('session');
        $kring_id = $this->session->userdata('kring_id');

        $kring_name = $this->input->get('kring');
        $this->kring = new Kring();
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
            return show_404();
        }

        $this->settings = new KringSetting();
        $this->settings->get_by_kring_id($this->kring->id);
        if($this->settings->enable_gui != 1) {
            return show_404();
        }
    }
}
