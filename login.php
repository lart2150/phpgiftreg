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

require_once(dirname(__FILE__) . "/includes/funcLib.php");
require_once(dirname(__FILE__) . "/includes/MySmarty.class.php");
$smarty = new MySmarty();
$opt = $smarty->opt();

if (getParam("action") == "logout") {
	session_start();
	// logout links carry the CSRF token, so other sites can't log people out.
	if (isset($_SESSION["userid"]) && !hash_equals(csrfToken(), getParam("csrf"))) {
		header("Location: " . getFullPath("index.php"));
		exit;
	}
	session_destroy();
}

if (!empty($_POST["username"])) {
	$username = $_POST["username"];
	$password = isset($_POST["password"]) ? $_POST["password"] : "";

	try {
		$dbh = $smarty->dbh();
		$row = false;
		if (loginIsThrottled($username, $dbh, $opt)) {
			// don't even check the password while throttled.
			list(, , $lockoutMinutes) = loginThrottleLimits($opt);
			$smarty->assign('error', "Too many failed login attempts.  Please wait $lockoutMinutes minutes and try again.");
		}
		else {
			$stmt = $dbh->prepare("SELECT userid, fullname, admin, password FROM {$opt["table_prefix"]}users WHERE username = ? AND approved = 1");
			$stmt->bindParam(1, $username, PDO::PARAM_STR);

			$stmt->execute();
			while ($candidate = $stmt->fetch()) {
				if (verifyPassword($password, $candidate["password"], $opt, $needsRehash)) {
					$row = $candidate;
					break;
				}
			}
			if (!$row) {
				recordLoginFailure($username, $dbh, $opt);
			}
		}
		if ($row) {
			clearLoginFailures($username, $dbh, $opt);
			if ($needsRehash) {
				// upgrade legacy (MD5/SHA1/plaintext) or outdated hashes to password_hash().
				// a failure here must never block the login itself.
				try {
					$newhash = hashPassword($password);
					$upd = $dbh->prepare("UPDATE {$opt["table_prefix"]}users SET password = ? WHERE userid = ?");
					$upd->bindValue(1, $newhash, PDO::PARAM_STR);
					$upd->bindValue(2, (int) $row["userid"], PDO::PARAM_INT);
					$upd->execute();

					// if the password column is too narrow MySQL (non-strict mode) silently
					// truncates the hash, which would lock the user out.  verify, and put
					// the old value back if so.
					$chk = $dbh->prepare("SELECT password FROM {$opt["table_prefix"]}users WHERE userid = ?");
					$chk->bindValue(1, (int) $row["userid"], PDO::PARAM_INT);
					$chk->execute();
					if ($chk->fetchColumn() !== $newhash) {
						error_log("phpgiftreg: password rehash for userid {$row["userid"]} did not persist; is users.password at least VARCHAR(255)? See sql/password-hash-upgrade.sql");
						$upd->bindValue(1, $row["password"], PDO::PARAM_STR);
						$upd->execute();
					}
				}
				catch (PDOException $e) {
					error_log("phpgiftreg: password rehash failed for userid {$row["userid"]}: " . $e->getMessage());
				}
			}

			session_start();
			// new session id on login (prevents session fixation), and a fresh
			// CSRF token for the new session.
			session_regenerate_id(true);
			unset($_SESSION["csrf_token"]);
			$_SESSION["userid"] = $row["userid"];
			$_SESSION["fullname"] = $row["fullname"];
			$_SESSION["admin"] = $row["admin"];
		
			header("Location: " . getFullPath("index.php"));
			exit;
		}
	}
	catch (PDOException $e) {
		failWithError($e);
	}

	$smarty->assign('username', $username);
	$smarty->display('login.tpl');
}
else {
	if (getParam("reset") == "1") {
		$smarty->assign('message', "Your password has been changed.  Please log in.");
	}
	$smarty->display('login.tpl');
}
?>
