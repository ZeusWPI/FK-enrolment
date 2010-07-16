<?php
/**
 * Group of functions to verify API-keys
 */

// random IV
define('APIKEY_IV', base64_decode('y76NCxitTRU='));
define('APIKEY_ENCRYPTION', MCRYPT_BLOWFISH);

function apikey_encrypt($kring_id) {
    $CI =& get_instance();
    $key = $CI->config->item('rest_apikey_secret');
    $value = $kring_id . '+' . substr(sha1($kring_id), 0, 8);

    $data = mcrypt_encrypt(APIKEY_ENCRYPTION, $key, $value, MCRYPT_MODE_CFB, APIKEY_IV);

    return base64_url_encode($data);
}

function apikey_decrypt($data) {
    $CI =& get_instance();
    $key = $CI->config->item('rest_apikey_secret');

    $data = base64_url_decode($data);
    
    return mcrypt_decrypt(APIKEY_ENCRYPTION, $key, $data, MCRYPT_MODE_CFB, APIKEY_IV);
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
function apikey_verify($data) {
    $decrypted = explode('+', apikey_decrypt($data));
    if(count($decrypted) == 2) {
        $hash = substr(sha1($decrypted[0]), 0, 8);
        return ($hash == $decrypted[1]) ? $decrypted[0] : -1;
    } else {
        return -1;
    }
}