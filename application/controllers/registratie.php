<?php

class Registratie extends Controller {
    function index() {
        $this->template->set('pageTitle', 'Inschrijven');
        $this->template->load('layout', 'register/start');
    }
}
