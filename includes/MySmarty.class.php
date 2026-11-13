<?php

// Smarty 5's libs/Smarty.class.php registers its own autoloader (no Composer needed).
require_once(dirname(__FILE__) . "/Smarty-5.8.5/libs/Smarty.class.php");
require_once(dirname(__FILE__) . "/config.php");

class MySmarty extends \Smarty\Smarty {
	public function __construct() {
		parent::__construct();

		// HTML-escape every {$var} by default.  Templates that intentionally
		// output trusted HTML must use {$var nofilter}.
		$this->escape_html = true;

		date_default_timezone_set("GMT+0");
	}

	public function dbh() {
		$opt = $this->opt();
		return new PDO(
			$opt["pdo_connection_string"],
			$opt["pdo_username"],
			$opt["pdo_password"]);
	}

	public function opt() {
		static $opt;
		if (!isset($opt)) {
			$opt = getGlobalOptions();
		}
		return $opt;
	}

	public function display($t = NULL, $cache_id = NULL, $compile_id = NULL) {
		$isadmin = isset($_SESSION['admin']) ? $_SESSION['admin'] : false;
		parent::assign('isadmin', $isadmin);
		parent::assign('opt', $this->opt());
		parent::assign('csrf', function_exists('csrfToken') ? csrfToken() : '');
		parent::display($t, $cache_id, $compile_id);
	}
}
?>
