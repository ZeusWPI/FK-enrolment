<?php  if (!defined('BASEPATH')) exit('No direct script access allowed');
/**
 * Migrations
 *
 * An open source utility for Code Igniter inspired by Ruby on Rails
 *
 * Note: This is a work in progress. Merely a wrapper for all the currently
 * existing DBUtil class, and a CI adaptation of all the RoR conterparts.
 * many of the methods in this helper might not function properly in some DB
 * engines and other are not yet finished developing.
 * This helper is being released as a complement for the Migrations utility.
 *
 * @package		Migrations
 * @author		Matías Montes
 */

// ------------------------------------------------------------------------

/**
 * Migrations DB Utility helpers.
 * An extension to Code Igniter dbutility class in helper format.
 *
 * @package		Migrations
 * @subpackage	Helpers
 * @category	Helpers
 * @author		Matías Montes
 */

// ------------------------------------------------------------------------

/**
 * Create database
 *
 * A wrapper for DB_utility::create_database
 *
 * @link http://codeigniter.com/user_guide/database/utilities.html#create
 */
function create_database($db_name) {

	$CI =& _get_instance_w_dbutil();
	return $CI->dbutil->create_database($db_name);

}

// ------------------------------------------------------------------------

/**
 * Drop database
 *
 * A wrapper for DB_utility::drop_database
 *
 * @link http://codeigniter.com/user_guide/database/utilities.html#drop
 */
function drop_database($db_name) {

	$CI =& _get_instance_w_dbutil();
	return $CI->dbutil->drop_database($db_name);

}

// ------------------------------------------------------------------------

/**
 * List Databases
 *
 * A wrapper for DB_utility::list_databases
 *
 * @link http://codeigniter.com/user_guide/database/utilities.html#list
 */
function list_databases($db_name) {

	$CI =& _get_instance_w_dbutil();
	return $CI->dbutil->list_databases($db_name);

}

// ------------------------------------------------------------------------

/**
 * Optimize Table
 *
 * A wrapper for DB_utility::optimize_table
 *
 * @link http://codeigniter.com/user_guide/database/utilities.html#opttb
 */
function optimize_table($table_name) {

	$CI =& _get_instance_w_dbutil();
	return $CI->dbutil->optimize_table($table_name);

}

// ------------------------------------------------------------------------

/**
 * Repair Table
 *
 * A wrapper for DB_utility::repair_table
 *
 * @link http://codeigniter.com/user_guide/database/utilities.html#repair
 */
function repair_table($table_name) {

	$CI =& _get_instance_w_dbutil();
	return $CI->dbutil->repair_table($table_name);

}

// ------------------------------------------------------------------------

/**
 * Optimize Databse
 *
 * A wrapper for DB_utility::optimize_database
 *
 * @link http://codeigniter.com/user_guide/database/utilities.html#optdb
 */
function optimize_database() {

	$CI =& _get_instance_w_dbutil();
	return $CI->dbutil->optimize_database();

}

// ------------------------------------------------------------------------

/**
 * Backup Database
 *
 * A wrapper for DB_utility::backup
 *
 * @link http://codeigniter.com/user_guide/database/utilities.html#backup
 */
function backup($params = array()) {

	$CI =& _get_instance_w_dbutil();
	return $CI->dbutil->backup();

}

// ------------------------------------------------------------------------

/**
 * Create Table
 *
 * Creates a new table
 *
 * $table_name:
 *
 * 		Name of the table to be created
 *
 * $fields:
 *
 * 		Associative array containing the name of the field as a key and the
 * 		value could be either a string indicating the type of the field, or an
 * 		array containing the field type at the first position and any optional
 * 		arguments the field might require in the remaining positions.
 * 		Refer to the TYPES function for valid type arguments.
 * 		Refer to the FIELD_ARGUMENTS function for valid optional arguments for a
 * 		field.
 *
 * $primary_keys:
 *
 * 		A string indicating the name of the field to be set as a unique primary
 * 		key or an array listing the fields to be set as a combined key.
 * 		If a field is selected as a primary key and its type is integer, it
 * 		will be set as an incremental field (auto_increment in mysql, serial in
 * 		postgre, etc).
 *
 * @example
 *
 *		create_table (
 * 			'blog',
 * 			array (
 * 				'id' => array ( INTEGER ),
 * 				'title' => array ( STRING, LIMIT, 50, DEFAULT, "The blog's title." ),
 * 				'date' => DATE,
 * 				'content' => TEXT
 * 			),
 * 			'id'
 * 		)
 *
 * @access	public
 * @param	string $table_name
 * @param	array $fields
 * @param	mixed $primary_keys
 * @return	boolean
 */
function create_table($table_name, $fields, $primary_keys = FALSE) {

	$CI =& _get_instance_w_dbutil();

	switch ( $CI->db->platform() ) {

		case 'mysql':
		default:

			if ( !empty($primary_keys) ) $primary_keys = (array)$primary_keys;
			$sql = "CREATE TABLE `{$table_name}` (";

			foreach ( $fields as $field_name => $params ) {

				$params = (array)$params;

				// Get the default Limit

				switch ( $params[0] ) {

					case DECIMAL: $default_limit = "(10,0)"; break;
					case INTEGER: $default_limit = "(11)"; break;
					case STRING:  $default_limit = "(255)"; break;
					case BINARY:  $default_limit = "(1)"; break;
					case BOOLEAN: $default_limit = "(1)"; break;
					default: $default_limit = "";

				}

				$sql .= "`{$field_name}` {$params[0]}";
				$sql .= in_array(LIMIT,$params,true) ? "(" . $params[array_search(LIMIT,$params,true) + 1] . ") " : $default_limit . " ";
				$sql .= in_array(DEFAULT_VALUE,$params,true) ? "default " . $CI->db->escape($params[array_search(DEFAULT_VALUE,$params,true) + 1]) . " " : "";
				$sql .= in_array(NOT_NULL,$params,true) ? "NOT NULL " : "NULL ";
				$sql .= in_array($field_name,$primary_keys,true) && $params[0] == INTEGER ? "auto_increment " : "";
				$sql .= ",";

			}

			$sql = rtrim($sql,',');

			if ( !empty($primary_keys) ) {

				$sql .= ",PRIMARY KEY (";

				foreach ( $primary_keys as $pk ) {
					$sql .= "`{$pk}`,";
				}

				$sql = rtrim($sql,',');
				$sql .= ")";

			}

			$sql .= ")";

		break;
	}

	return $CI->db->query($sql);

}

// ------------------------------------------------------------------------

/**
 * Drop a table
 *
 * @param string $table_name
 * @return boolean
 */
function drop_table($table_name) {

	$CI =& _get_instance_w_dbutil();
	return $CI->db->query("DROP TABLE {$table_name}");

}

// ------------------------------------------------------------------------

/**
 * Rename a table
 *
 * @access public
 * @param string $old_name
 * @param string $new_name
 * @return boolean
 */
function rename_table($old_name, $new_name) {

	$CI =& _get_instance_w_dbutil();

	switch ( $CI->db->platform() ) {

		case 'mysql':
		default:

			$sql = "RENAME TABLE `{$old_name}`  TO `{$new_name}` ;";
			break;

	}

	return $CI->db->query($sql);

}

// ------------------------------------------------------------------------

/**
 * Add a column to a table
 *
 * @example add_column ( "the_table", "the_field", STRING, array(LIMIT, 25, NOT_NULL) );
 * @access public
 * @param string $table_name
 * @param string $column_name
 * @param string $type
 * @param array $arguments
 * @return boolean
 */
function add_column($table_name,$column_name,$type,$arguments=array()) {

	$CI =& _get_instance_w_dbutil();

	switch ( $CI->db->platform() ) {

		case 'mysql':
		default:

			$sql = "ALTER TABLE `{$table_name}` ADD `{$column_name}` {$type}";

			// Get the default Limit

			switch ( $type ) {

				case DECIMAL: $default_limit = "(10,0)"; break;
				case INTEGER: $default_limit = "(11)"; break;
				case STRING:  $default_limit = "(255)"; break;
				case BINARY:  $default_limit = "(1)"; break;
				case BOOLEAN: $default_limit = "(1)"; break;
				default: $default_limit = "";

			}

			$sql .= in_array(LIMIT,$arguments,true) ? "(" . $arguments[array_search(LIMIT,$arguments,true) + 1] . ") " : $default_limit . " ";
			$sql .= in_array(DEFAULT_VALUE,$arguments,true) ? "default " . $CI->db->escape($arguments[array_search(DEFAULT_VALUE,$arguments,true) + 1]) . " " : "";
			$sql .= in_array(NOT_NULL,$arguments,true) ? "NOT NULL " : "NULL ";
			break;

	}

	return $CI->db->query($sql);

}

// ------------------------------------------------------------------------

/**
 * Rename a column
 *
 * @access public
 * @param string $table_name
 * @param string $column_name
 * @param string $new_column_name
 */
function rename_column($table_name, $column_name, $new_column_name) {

	// TO DO

}

// ------------------------------------------------------------------------

function change_column($table_name, $column_name, $type, $options) {

	// TO DO

}

// ------------------------------------------------------------------------

/**
 * Remove a column from a table
 *
 * @access public
 * @param string $table_name
 * @param string $column_name
 * @return boolean
 */
function remove_column($table_name, $column_name) {

	$CI =& _get_instance_w_dbutil();
	return $CI->db->query("ALTER TABLE {$table_name} DROP COLUMN {$column_name}");

}

// ------------------------------------------------------------------------

function add_index($table_name, $column_names, $index_name, $index_type = 'INDEX') {

	// TO DO
	
	$CI = _get_instance_w_dbutil();

	switch ( $CI->db->platform() ) {
		case 'mysql':
		default:
			$sql = "ALTER TABLE `{$table_name}` ADD {$index_type} `{$index_name}` (`{$column_names}`)";
			break;

	}

	return $CI->db->query($sql);
}

// ------------------------------------------------------------------------

function remove_index($table_name, $column_name) {

	// TO DO

}

// ------------------------------------------------------------------------

/**
 * Retrieves CI framework and loads DB and DBUtil if not yet loaded
 *
 * @return &CI_Base
 */
function &_get_instance_w_dbutil() {

	$CI =& get_instance();
	if(empty($CI->db)) $CI->load->database();
	if(empty($CI->dbutil)) $CI->load->dbutil();
	return $CI;

}

// ------------------------------------------------------------------------

/**
 * Defines standard Data type constants
 *
 * @access private
 */
function TYPES() {

	if ( defined("DBUTIL_TYPES")) return;
	define("DBUTIL_TYPES",1);
	$CI =& _get_instance_w_dbutil();

	switch ( $CI->db->platform() ) {

		case "mysql":
		default:

			define("DECIMAL","decimal");		// Real number
			define("INTEGER","int");			// Standard integer
			define("FLOAT","float");			// Real number
			define("DATETIME","datetime");		// Date and time
			define("DATE","date");				// Date
			define("TIMESTAMP","timestamp");	// Date and time
			define("TIME","time");				// Time
			define("TEXT","text");				// Long string
			define("STRING","varchar");			// Standard string
			define("BINARY","binary");			// Binary object
			define("BOOLEAN","tinyint");			// True or false
			break;

	}
}

// ------------------------------------------------------------------------

/**
 * Defines standard field arguments constants
 *
 * @access private
 */
function FIELD_ARGUMENTS() {

	if ( defined('DBUTIL_FIELD_ARGUMENTS') ) return;
	define('DBUTIL_FIELD_ARGUMENTS',1);
	$CI =& _get_instance_w_dbutil();

	switch ( $CI->db->platform() ) {

		case "mysql":
		default:

			define("NOT_NULL","null");			// The field cannot be set to NULL value. (by default, it can)
			define("LIMIT","([limit])");		// Set a maximum length for the field.*
			define("DEFAULT_VALUE","default");	// Set a default value for the field when it is not set. *

			// * When passing this argument, the following argument in the array should contain the desired value.

			break;

	}

}

TYPES();
FIELD_ARGUMENTS();