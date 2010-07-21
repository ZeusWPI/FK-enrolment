<?php

class Gui extends Controller {
	function index()
	{
        $this->template->set('pageTitle', 'Welkom op het FK inschrijvingssysteem.');
        $this->template->load('layout', 'welcome');
	}
}
