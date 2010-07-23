<?php

class Home extends MY_Controller {
	function index() {
        $kringen = new Kring();
        $kringen->order_by('lang')->get_where(array('actief' => 1, 'showonsite' => 1));

        $this->template->set('pageTitle', 'Home');
        $this->template->load('layout', 'welcome', array('kringen' => $kringen->all));
	}

    function login() {
        $this->load->library('phpCAS');

        phpCAS::client(CAS_VERSION_3_0,'login.ugent.be', 443, '', true, 'saml');
        phpCAS::handleLogoutRequests(true, array('cas1.ugent.be','cas2.ugent.be','cas3.ugent.be','cas4.ugent.be'));
        phpCAS::setExtraCurlOption(CURLOPT_SSLVERSION, 3);
        //phpCAS::setNoCasServerValidation();
        phpCAS::forceAuthentication();
    }
}
