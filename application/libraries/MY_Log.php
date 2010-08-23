<?php
/**
 * MY_Log Class
 *
 * This library extends the native Log library.
 * It adds the function to have the log messages being emailed when they have been outputted to the log file.
 *
 * @package		CodeIgniter
 * @subpackage		Libraries
 * @category		Logging
 * @author		Johan Steen
 * @link		http://wpstorm.net/
 */
class MY_Log extends CI_Log {
	/**
	 * Constructor
	 *
	 * @access	public
	 */
	function MY_Log()
	{
		parent::CI_Log();
	}

	/**
	 * Write Log File
	 *
	 * Calls the native write_log() method and then sends an email if a log message was generated.
	 *
	 * @access	public
	 * @param	string	the error level
	 * @param	string	the error message
	 * @param	bool	whether the error is a native PHP error
	 * @return	bool
	 */
	function write_log($level = 'error', $msg, $php_error = FALSE)
	{
		$result = parent::write_log($level, $msg, $php_error);

		if ($result == TRUE && strtoupper($level) == 'ERROR') {
			$message = "An error occurred: \n\n";
			$message .= $level.' - '.date($this->_date_fmt). ' --> '.$msg."\n";

			$to = 'fk-enrolment@thinkjavache.be';
			$subject = 'An error has occured';
			$headers = 'From: FK-enrolment <zeus@fkserv.ugent.be>' . "\r\n";
			$headers .= 'Content-type: text/plain; charset=utf-8\r\n';

			mail($to, $subject, $message, $headers);
		}
		return $result;
	}
}
?>