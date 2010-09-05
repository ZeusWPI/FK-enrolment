<?php

//FKforum_sid > phpbb3_sessions > phpbb3_users > (via username) > praesidia > kringen

function auth_user($sessionId) {
    $CI =& get_instance();
    $db = $CI->load->database('fk_intranet', true);

    $username = $db->query("SELECT username FROM phpbb3_sessions s
        LEFT JOIN phpbb3_users u ON u.user_id = s.session_user_id
        WHERE s.session_id = ?", $sessionId)->row_array();

    // attempt 1


    //FKforum_sid > phpbb3_sessions > phpbb3_users > (via username) > praesidia > kringen
}