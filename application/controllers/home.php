<?php

class Home extends Controller {
	function index() {
        $this->template->set('pageTitle', 'Home');
        $this->template->load('layout', 'welcome');
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
