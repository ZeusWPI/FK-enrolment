<?php

class Api_Test extends Controller {

    function __construct() {
        parent::Controller();

        $this->load->library('rest', array(
            'server' => $this->config->item('base_url') . 'api'
        ));
    }

    function add_user($scenario = 0) {
        $scenarios = array();

         // everything filled in
        $scenarios[0] = array(
            'kring_id' => 28, 'first_name' => 'Pieter', 'last_name' => 'De Baets',
            'email' => 'pieter.debaets@ugent.be', 'ugent_nr' => '0081234',
            'ugent_login' => 'pdbaets', 'cellphone' => '0473888888',
            'address_home' => "Thuisstraat 10\n9000 Gent",
            'address_kot' => "Kotstraat 5\n9000 Gent"
        );

        // nothing filled in
        $scenarios[1] = array();
        
        $result = $this->rest->post('add_member.json?key=b93206de99b5b9a', $scenarios[$scenario]);
        var_dump($result);
    }
}
