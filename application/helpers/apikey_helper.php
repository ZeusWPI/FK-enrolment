<?php
/**
 * Group of functions to verify API-keys
 */

// random IV
define('API_KEY_IV', base64_decode('y76NCxitTRU='));
define('API_KEY_ENCRYPTION', MCRYPT_BLOWFISH);

function api_key_encrypt($kring_id) {
    $CI =& get_instance();
    $key = $CI->config->item('rest_api_key_secret');
    $value = $kring_id . '+' . substr(sha1($kring_id), 0, 8);

    $data = mcrypt_encrypt(API_KEY_ENCRYPTION, $key, $value, MCRYPT_MODE_CFB, API_KEY_IV);

    return base64_url_encode($data);
}

function api_key_decrypt($data) {
    $CI =& get_instance();
    $key = $CI->config->item('rest_api_key_secret');

    $data = base64_url_decode($data);
    
    return mcrypt_decrypt(API_KEY_ENCRYPTION, $key, $data, MCRYPT_MODE_CFB, API_KEY_IV);
}

function base64_url_encode($input) {
    return strtr(base64_encode($input), '+/=', '-_,');
}

function base64_url_decode($input) {
    return base64_decode(strtr($input, '-_,', '+/='));
}

/**
 * Verify an API-key
 * @param string $key
 * @return integer $kring_id, -1 if invalid
 */
function api_key_verify($data) {
    $decrypted = explode('+', api_key_decrypt($data));
    if(count($decrypted) == 2) {
        $hash = substr(sha1($decrypted[0]), 0, 8);
        return ($hash == $decrypted[1]) ? $decrypted[0] : -1;
    } else {
        return -1;
    }
}
