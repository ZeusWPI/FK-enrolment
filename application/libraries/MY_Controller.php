<?php

class MY_Controller extends Controller {
    public function __construct() {
        parent::Controller();

        $this->loadSidebar();
    }

    private function loadSidebar() {
        // @TODO: sponsors
    }
}