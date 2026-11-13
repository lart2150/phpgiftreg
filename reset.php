<?php
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

// Choose a new password using the one-time link e-mailed by forgot.php.

require_once(dirname(__FILE__) . "/includes/funcLib.php");
require_once(dirname(__FILE__) . "/includes/MySmarty.class.php");
$smarty = new MySmarty();
$opt = $smarty->opt();

$token = requestParam("token");
$reset = false;

try {
	$dbh = $smarty->dbh();
	if (preg_match('/^[0-9a-f]{64}$/', $token)) {
		$stmt = $dbh->prepare("SELECT r.userid, u.username FROM {$opt["table_prefix"]}password_resets r " .
			"INNER JOIN {$opt["table_prefix"]}users u ON u.userid = r.userid " .
			"WHERE r.token_hash = ? AND r.expires > NOW()");
		$stmt->bindValue(1, hash("sha256", $token), PDO::PARAM_STR);
		$stmt->execute();
		$reset = $stmt->fetch();
	}

	if ($reset && postParam("action") == "reset") {
		$newpwd = postParam("newpwd");
		if ($newpwd == "") {
			$error = "Please enter a new password.";
		}
		else if ($newpwd !== postParam("confirmpwd")) {
			$error = "The passwords don't match.";
		}
		else {
			$stmt = $dbh->prepare("UPDATE {$opt["table_prefix"]}users SET password = ? WHERE userid = ?");
			$stmt->bindValue(1, hashPassword($newpwd), PDO::PARAM_STR);
			$stmt->bindValue(2, (int) $reset["userid"], PDO::PARAM_INT);
			$stmt->execute();

			// the link is single-use.
			$stmt = $dbh->prepare("DELETE FROM {$opt["table_prefix"]}password_resets WHERE userid = ?");
			$stmt->bindValue(1, (int) $reset["userid"], PDO::PARAM_INT);
			$stmt->execute();
			clearLoginFailures($reset["username"], $dbh, $opt);

			header("Location: " . getFullPath("login.php?reset=1"));
			exit;
		}
	}
}
catch (PDOException $e) {
	failWithError($e);
}

$smarty->assign('valid', $reset ? true : false);
$smarty->assign('token', $token);
$smarty->assign('username', $reset ? $reset["username"] : "");
if (isset($error)) {
	$smarty->assign('error', $error);
}
$smarty->display('reset.tpl');
?>
