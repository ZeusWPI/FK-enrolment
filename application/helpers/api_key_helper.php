<?php
/**
 * Group of functions to generates verify API-keys
 */

function generate_api_key($kring_id) {
    return substr(sha1('zeus-wpi' . $kring_id . rand()), 0, 12);
}

log_message('error', generate_api_key(2));

function get_api_key($kring_id) {
    $CI =& get_instance();
	if(empty($CI->db)) $CI->load->database();

    $kring = new KringSetting();
    $kring->get_by_kring_id($kring_id);
    return $kring->api_key;
}

/**
 * Verify an API-key
 * @param string $key
 * @return integer $kring_id, -1 if invalid
 */
function api_key_verify($key) {
    $CI =& get_instance();
	if(empty($CI->db)) $CI->load->database();

    $settings = new KringSetting();
    $settings->get_where(array(
        'enable_api' => 1,
        'api_key' => $key
    ));

    return count($settings->all) == 1 ? $settings->kring_id : -1;
}
