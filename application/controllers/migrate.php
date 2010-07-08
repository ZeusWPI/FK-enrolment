<?php  if (!defined('BASEPATH')) exit('No direct script access allowed');
/**
 * Migrations
 *
 * An open source utility for Code Igniter inspired by Ruby on Rails
 *
 * @package		Migrations
 * @author		Matías Montes
 */

// ------------------------------------------------------------------------

/**
 * Migrate Class
 *
 * Utility main controller.
 *
 * @package		Migrations
 * @author		Matías Montes
 */
class Migrate extends Controller {

	var $migrations_enabled = FALSE;
	var $migrations_path = ".";

	function Migrate() {

		parent::Controller();
		$this->lang->load("migrations");
		if(is_file(APPPATH."config/migrations.php")) include APPPATH."config/migrations.php";

		if( empty($config) || !is_array($config) ) {

			// Configuration should be in the default CI format
			show_error($this->lang->line('config_corrupted'));

		}

		foreach ( $config as $k => $v ) $this->$k = $v;
		if ( !$this->migrations_enabled ) show_404();

		if ( $this->migrations_path != '' && substr($this->migrations_path, -1) != '/' )
			$this->migrations_path .= '/';

	}

	// --------------------------------------------------------------------

	/**
	 * "Empty" Call
	 *
	 * Defines a default view for a no-parameter call.
	 *
	 * @access public
	 * @return void		Outputs the default view
	 */
	function index() {

		show_error($this->lang->line("must_call"));

	}

	// --------------------------------------------------------------------

	/**
	 * Installs the schema up to the last version
	 *
	 * @access	public
	 * @return	void	Outputs a report of the installation
	 */
	function install() {

		$files = glob($this->migrations_path."*".EXT);
		$file_count = count($files);

		for ( $i = 0 ; $i < $file_count ; $i++ ) {

			// Mark wrongly formatted files as FALSE for later filtering
			$name = basename($files[$i],EXT);
			if(!preg_match('/^\d{3}_(\w+)$/',$name)) $files[$i] = FALSE;

		}

		$migrations = array_filter($files);

		if ( !empty($migrations) ) {

			sort($migrations);
			$last_migration = basename(end($migrations));

			// Calculate the last migration step from existing migration
			// filenames and procceed to the standard version migration
			$last_version =	substr($last_migration,0,3);
			$this->version(intval($last_version,10));

		} else {

			show_error($this->lang->line("no_migrations_found"));

		}

	}

	// --------------------------------------------------------------------

	/**
	 * Migrate to a schema version
	 *
	 * Calls each migration step required to get to the schema version of
	 * choice
	 *
	 * @access	public
	 * @param $version integer	Target schema version
	 * @return	void			Outputs a report of the migration
	 */
	function version($version=0) {

		$schema_version = $this->_get_schema_version();
		$start = $schema_version;
		$stop = $version;

		if ( $version > $schema_version ) {

			// Moving Up
			$start++;
			$stop++;
			$step = 1;

		} else {

			// Moving Down
			$step = -1;

		}

		$method = $step == 1 ? 'up' : 'down';
		$migrations = array();

		// We now prepare to actually DO the migrations

		// But first let's make sure that everything is the way it should be
		for ( $i = $start ; $i != $stop ; $i += $step ) {

			$f = glob(sprintf($this->migrations_path . '%03d_*.php', $i));

			if ( count($f) > 1 ) // Only one migration per step is permitted
				show_error(sprintf($this->lang->line("multiple_migrations_version"),$i));

			if ( count($f) == 0 ) { // Migration step not found

				// If trying to migrate up to a version greater than the last
				// existing one, migrate to the last one.
				if ( $step == 1 ) break;

				// If trying to migrate down but we're missing a step,
				// something must definitely be wrong.
				else show_error(sprintf($this->lang->line("migration_not_found")),$i);

			}

			$file = basename($f[0]);
			$name = basename($f[0],EXT);

			// Filename validations
			if ( preg_match('/^\d{3}_(\w+)$/', $name, $match) ) {

				$match[1] = strtolower($match[1]);

				if ( in_array($match[1], $migrations) )
					// Cannot repeat a migration at different steps
					show_error(sprintf($this->lang->line("multiple_migrations_name"),$match[1]));

				include $f[0];
				$class = ucfirst($match[1]);

				if ( !class_exists($class) )
					show_error(sprintf($this->lang->line("migration_class_doesnt_exist"),$class));

				if ( !is_callable(array($class,"up")) || !is_callable(array($class,"down")) )
					show_error(sprintf($this->lang->line('wrong_migration_interface'),$class));

				$migrations[] = $match[1];

			} else show_error(sprintf($this->lang->line("invalid_migration_filename"),$file));

		}

		$version = $i + ($step == 1 ? -1 : 0);

		if ( count($migrations) ) { // If there is any migration to proccess

			echo "<p>Current schema version: ".$schema_version."<br/>";
			echo "Moving ".$method." to version ".$version."</p>";
			echo "<hr/>";

			foreach ( $migrations as $m ) {

				// This is what this is all about

				echo "$m:<br />";
				echo "<blockquote>";
				$class = ucfirst($m);
				call_user_func(array($class, $method));
				echo "</blockquote>";
				echo "<hr/>";
				$schema_version += $step;
				$this->_update_schema_version($schema_version);

			}

			echo "<p>All done. Schema is at version $schema_version.</p>";

		} else echo "Nothing to do, bye!\n";

	}

	// --------------------------------------------------------------------

	/**
	 * Retrieves current schema version
	 *
	 * @access	private
	 * @return	integer	Current Schema version
	 */
	function _get_schema_version() {

		if ( !is_dir($this->migrations_path . ".info") )
			mkdir($this->migrations_path . ".info");

		if ( !file_exists($this->migrations_path . '.info/version') ) {

			$fversion = fopen($this->migrations_path . '.info/version','w');
			fwrite($fversion,'0');
			fclose($fversion);
			return 0;

		} else {

			$fversion = fopen($this->migrations_path . '.info/version','r');
			$version = fread($fversion,11);
			fclose($fversion);
			return $version;

		}

		return 0;

	}

	// --------------------------------------------------------------------

	/**
	 * Stores the current schema version
	 *
	 * @access	private
	 * @param $schema_version integer	Schema version reached
	 * @return	void					Outputs a report of the migration
	 */
	function _update_schema_version($schema_version) {

		$fversion = fopen($this->migrations_path . '.info/version','w');
		fwrite($fversion,$schema_version);
		fclose($fversion);

	}

}

?>