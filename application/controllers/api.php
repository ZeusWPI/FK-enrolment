<?php

require(APPPATH.'/libraries/REST_Controller.php');

class Api extends REST_Controller
{
    function index_get() {
        // @TODO: provide some info about the api
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
}
