<?php

require(APPPATH.'/libraries/REST_Controller.php');

class Api extends REST_Controller
{
    function index_get() {
        $this->load->view('api');
    }

    function add_member_post()
    {
        // @TODO add validation of api key

        $member = new Member();
        $member->kring_id = $this->post('kring_id'); // determine with api key?
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

        $result = array(
            'status' => $member->valid ? 'OK' : 'ERROR',
            'errors' => array_map('strip_tags', $member->error->all),
            'return' => $member->valid ? array('member_id' => $member->id) : array()
        );

        $this->response($result, 200); // 200 being the HTTP response code
    }

    function barcode_get() {
        if($this->_format != 'png') {
            $this->response(array(
                'status' => 'ERROR',
                'errors' => array('Only the png-format is valid for this method.'),
                'return' => null
            ), 415); // Unsupported Media Type
            return;
        }

        $member_id = str_pad(abs($this->get('member_id')), 13, '0', STR_PAD_LEFT);

        require_once('Image/Barcode.php');
        Image_Barcode::draw($member_id, 'ean13', 'png');
    }
}
