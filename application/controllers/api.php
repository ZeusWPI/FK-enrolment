<?php

require(APPPATH.'/libraries/REST_Controller.php');

class Api extends REST_Controller {
    
    public function index_get() {
        $this->load->view('api');
    }

    private function error($messages, $status_code = 404) {
        return $this->response(array(
            'status' => 'ERROR',
            'errors' => is_array($messages) ? $messages : array($messages),
            'return' => null
        ), $status_code);
    }

    public function add_member_post()
    {
        $kring_id = api_key_verify($this->get('key'));
        if($kring_id == -1) {
            return $this->error('Please provide a valid API-key', 403);
        }

        $member = new Member();
        $member->kring_id = $kring_id;
        $member->first_name = $this->post('first_name');
        $member->last_name = $this->post('last_name');
        $member->email = $this->post('email');
        $member->ugent_nr = $this->post('ugent_nr');
        $member->ugent_login = $this->post('ugent_login');
        $member->cellphone = $this->post('cellphone');
        $member->address_home = $this->post('address_home');
        $member->address_kot = $this->post('address_kot');

        if($member->validate()->valid) {
            $member->save();
            $member->log($member->id, 'api', 'created member');
        } else {
            $member->log(-1, 'api', 'creating member failed');
        }

        $this->response(array(
            'status' => $member->valid ? 'OK' : 'ERROR',
            'errors' => array_map('strip_tags', $member->error->all),
            'return' => $member->valid ? array('member_id' => $member->id) : array()
        ), 200); // 200 being the HTTP response code
    }

    public function associate_card_post() {
        $kring_id = api_key_verify($this->get('key'));
        if($kring_id == -1) {
            return $this->error('Please provide a valid API-key', 403);
        }

        $card = new AssociatedCard();
        $card->member_id = $this->post('member_id');
        $card->card_id = $this->post('card_id');
        $card->academic_year = $this->config->item('academic_year');

        if($card->validate($kring_id)->valid) {
            $card->save();

            // Very ugly but DataMapper + CI suck like a balinese hooker at peak hour
            $member = new Member();
            $member->log($card->member_id, 'api', 'associated card #'.$card->card_id);
        }

        $this->response(array(
            'status' => $card->valid ? 'OK' : 'ERROR',
            'errors' => array_map('strip_tags', $card->error->all),
            'return' => array()
        ), 200);
    }

    public function generate_key_get() {
        if(!DEBUG) {
            return $this->error('Generating keys is not available right now.', 403);
        }
        
        $kring_id = $this->get('kring_id');
        echo api_key_encrypt($kring_id);
    }

    public function barcode_get() {
        $member_id = str_pad(abs($this->get('member_id')), 13, '0', STR_PAD_LEFT);

        require_once('Image/Barcode.php');
        Image_Barcode::draw($member_id, 'ean13', 'png');
    }
}
