<?php

//FKforum_sid > phpbb3_sessions > phpbb3_users > (via username) > praesidia > kringen

function auth_user($sessionId) {
    $CI =& get_instance();
    $db = $CI->load->database('fk_intranet', true);
    if(empty($sessionId)) return -1;
	
    $username = $db->query("SELECT username FROM phpbb3_sessions s
        LEFT JOIN phpbb3_users u ON u.user_id = s.session_user_id
        WHERE s.session_id = ?", array($sessionId))->row_array();
    if(empty($username)) return -1;

    // attempt 1: username is user
    $kring = $db->query("SELECT k.* FROM praesidia p
        INNER JOIN kringen k ON p.kring = k.id
        WHERE p.ugentlogin = ? AND p.jaar=? AND k.showonsite = 1",
        array($username['username'], $CI->config->item('academic_year')))->row_array();

    // attempt 2: username is kring
    if(empty($kring)) {
        $kring = $db->query("SELECT k.* FROM kringen k
            WHERE k.kringname = ? AND k.showonsite = 1",
            array($username['username']))->row_array();
    }

    if(empty($kring)) return -1;
    else return $kring['ID'];
}
