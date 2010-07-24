<?php
if(!DEBUG) exit('No access allowed');

class Api_Test extends Controller {

    function __construct() {
        parent::Controller();

        $this->load->library('rest', array(
            'server' => $this->config->item('base_url') . 'api'
        ));
    }

    function add_member($scenario = 0) {
        $scenarios = array();

         // everything filled in => should succeed
        $scenarios[0] = array(
            'first_name' => 'Pieter', 'last_name' => 'De Baets',
            'email' => 'pieter.debaets@ugent.be', 'ugent_nr' => '0081234',
            'ugent_login' => 'pdbaets', 'cellphone' => '0473888888',
            'address_home' => "Thuisstraat 10\n9000 Gent",
            'address_kot' => "Kotstraat 5\n9000 Gent"
        );

        // nothing filled in => should fail
        $scenarios[1] = array();

        // partially filled => should fail
        $scenarios[2] = array(
            'first_name' => 'Pieter', 'last_name' => 'De Baets',
        );

        // minimal => should succeed
        $scenarios[3] = array(
            'first_name' => 'Pieter', 'last_name' => 'De Baets', 'ugent_nr' => '0081234',
        );

        // minimal => should succeed
        $scenarios[4] = array(
            'first_name' => 'Pieter', 'last_name' => 'De Baets', 'email' => 'pieter.debaets@ugent.be',
        );

        $key = get_api_key(28);
        $result = $this->rest->post('add_member.json?key='.$key, $scenarios[$scenario]);
        var_dump($result);
    }

    function associate_card($scenario = 0) {
        $scenarios = array(); $keys = array();

        // everything filled in => should succeed
        $scenarios[0] = array(
            'member_id' => 1,
            'card_id' => '12356'
        );
        $keys[0] = get_api_key(28);

        // everything filled in, but wrong kring => should fail
        $scenarios[1] = $scenarios[0];
        $keys[1] = get_api_key(26);

        $result = $this->rest->post('associate_card.json?key='.$keys[$scenario],
                $scenarios[$scenario]);
        var_dump($result);
    }
}
