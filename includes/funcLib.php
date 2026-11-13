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

/* Session cookie hardening.  Must run before any session_start(); every page
	includes this file first. */
if (session_status() == PHP_SESSION_NONE && !headers_sent()) {
	ini_set("session.use_strict_mode", "1");		// reject attacker-chosen session ids
	ini_set("session.use_only_cookies", "1");
	ini_set("session.cookie_httponly", "1");		// no JavaScript access to the cookie
	ini_set("session.cookie_samesite", "Lax");		// not sent on cross-site POSTs/subrequests
	if (isHttps()) {
		ini_set("session.cookie_secure", "1");
	}
}

/* Don't leak URLs (which may carry the CSRF token) to other sites via Referer. */
if (!headers_sent()) {
	header("Referrer-Policy: same-origin");
}

/* Read a request parameter as a string without PHP 8 "Undefined array key"
	warnings.  Missing parameters (e.g. unchecked checkboxes) and non-scalar
	values (e.g. ?x[]=1) return $default. */
function paramFrom($source, $name, $default = "") {
	return (isset($source[$name]) && is_scalar($source[$name])) ? (string) $source[$name] : $default;
}

function getParam($name, $default = "") {
	return paramFrom($_GET, $name, $default);
}

function postParam($name, $default = "") {
	return paramFrom($_POST, $name, $default);
}

function requestParam($name, $default = "") {
	return paramFrom($_REQUEST, $name, $default);
}

function isHttps() {
	return (!empty($_SERVER["HTTPS"]) && strtolower($_SERVER["HTTPS"]) != "off") ||
		(isset($_SERVER["SERVER_PORT"]) && $_SERVER["SERVER_PORT"] == "443");
}

/* Per-session token protecting state-changing requests against CSRF. */
function csrfToken() {
	if (session_status() != PHP_SESSION_ACTIVE) {
		return "";
	}
	if (empty($_SESSION["csrf_token"])) {
		$_SESSION["csrf_token"] = bin2hex(random_bytes(32));
	}
	return $_SESSION["csrf_token"];
}

function requireCsrf() {
	$sent = isset($_REQUEST["csrf"]) && is_string($_REQUEST["csrf"]) ? $_REQUEST["csrf"] : "";
	$token = csrfToken();
	if ($token == "" || !hash_equals($token, $sent)) {
		http_response_code(403);
		die("Invalid or missing security token.  Please go back, reload the page and try again.");
	}
}

/* Require a CSRF token when the request carries an action other than the
	given read-only ones (e.g. "edit" or "add", which only display a form). */
function requireCsrfForAction($readOnlyActions = array()) {
	$action = isset($_REQUEST["action"]) ? $_REQUEST["action"] : "";
	if ($action !== "" && !in_array($action, $readOnlyActions, true)) {
		requireCsrf();
	}
}

function isValidEmail($email) {
	return is_string($email) && filter_var($email, FILTER_VALIDATE_EMAIL) !== false;
}

function stripNewlines($s) {
	return str_replace(array("\r", "\n"), " ", (string) $s);
}

/* May $shopper shop for $owner (approved, not pending)? */
function canShopFor($shopper, $owner, $dbh, $opt) {
	$stmt = $dbh->prepare("SELECT pending FROM {$opt["table_prefix"]}shoppers WHERE shopper = ? AND mayshopfor = ?");
	$stmt->bindValue(1, (int) $shopper, PDO::PARAM_INT);
	$stmt->bindValue(2, (int) $owner, PDO::PARAM_INT);
	$stmt->execute();
	$row = $stmt->fetch();
	return $row && !$row["pending"];
}

function getFullPath($url) {
	$fp = isHttps() ? "https://" : "http://";
	$fp .= $_SERVER["HTTP_HOST"];
	$dir = dirname($_SERVER["PHP_SELF"]);
	if ($dir != "/")
		$fp .= $dir;
	$fp .= "/" . $url;
	return $fp;
}

function jsEscape($s) {
	return str_replace("\"","\\u0022",str_replace("'","\\'",str_replace("\r\n","\\r\\n",$s)));
}

function adjustAllocQuantity($itemid, $userid, $bought, $adjust, $dbh, $opt) {
	$howmany = getExistingQuantity($itemid, $userid, $bought, $dbh, $opt);
	if ($howmany == 0) {
		if ($adjust < 0) {
			// can't subtract anything from 0.
			return 0;
		}
		else {
			$stmt = $dbh->prepare("INSERT INTO {$opt["table_prefix"]}allocs(itemid,userid,bought,quantity) VALUES(?, ?, ?, ?)");
			$stmt->bindParam(1, $itemid, PDO::PARAM_INT);
			$stmt->bindParam(2, $userid, PDO::PARAM_INT);
			$stmt->bindParam(3, $bought, PDO::PARAM_BOOL);
			$stmt->bindParam(4, $adjust, PDO::PARAM_INT);
			$stmt->execute();
			return $howmany;
		}
	}
	else {
		/* figure out the real amount to adjust by, in case someone claims to have
			received 3 of something from a buyer when they only bought 2. */
		if ($adjust < 0) {
			if (abs($adjust) > $howmany)
				$actual = -$howmany;
			else
				$actual = $adjust;
		}
		else {
			$actual = $adjust;
		}
		
		if ($howmany + $actual == 0) {
			$stmt = $dbh->prepare("DELETE FROM {$opt["table_prefix"]}allocs WHERE itemid = ? AND userid = ? AND bought = ?");
			$stmt->bindParam(1, $itemid, PDO::PARAM_INT);
			$stmt->bindParam(2, $userid, PDO::PARAM_INT);
			$stmt->bindParam(3, $bought, PDO::PARAM_BOOL);
			$stmt->execute();
		}
		else {
			$stmt = $dbh->prepare("UPDATE {$opt["table_prefix"]}allocs " .
					"SET quantity = quantity + ? " .	// because "quantity + -5" is okay.
					"WHERE itemid = ? AND userid = ? AND bought = ?");
			$stmt->bindParam(1, $actual, PDO::PARAM_INT);
			$stmt->bindParam(2, $itemid, PDO::PARAM_INT);
			$stmt->bindParam(3, $userid, PDO::PARAM_INT);
			$stmt->bindParam(4, $bought, PDO::PARAM_BOOL);
			$stmt->execute();
		}
		return $actual;
	}
}

function getExistingQuantity($itemid, $userid, $bought, $dbh, $opt) {
	$stmt = $dbh->prepare("SELECT quantity FROM {$opt["table_prefix"]}allocs WHERE bought = ? AND userid = ? AND itemid = ?");
	$stmt->bindParam(1, $bought, PDO::PARAM_BOOL);
	$stmt->bindParam(2, $userid, PDO::PARAM_INT);
	$stmt->bindParam(3, $itemid, PDO::PARAM_INT);
	$stmt->execute();
	if ($row = $stmt->fetch()) {
		return $row["quantity"];
	}
	else {
		return 0;
	}
}

function processSubscriptions($publisher, $action, $itemdesc, $dbh, $opt) {
	// join the users table as a cheap way to get the guy's name without having to pass it in.
	$stmt = $dbh->prepare("SELECT subscriber, fullname FROM {$opt["table_prefix"]}subscriptions sub INNER JOIN {$opt["table_prefix"]}users u ON u.userid = sub.publisher WHERE publisher = ? AND (last_notified IS NULL OR DATE_ADD(last_notified, INTERVAL " . (int) $opt["notify_threshold_minutes"] . " MINUTE) < NOW())");
	$stmt->bindParam(1, $publisher, PDO::PARAM_INT);
	$stmt->execute();

	$msg = "";
	while ($row = $stmt->fetch()) {
		if ($msg == "") {
			// same message for each user but we need the fullname from the first row before we can assemble it.
			if ($action == "insert") {
				$msg = $row["fullname"] . " has added the item \"$itemdesc\" to their list.";
			}
			else if ($action == "update") {
				$msg = $row["fullname"] . " has updated the item \"$itemdesc\" on their list.";
			}
			else if ($action == "delete") {
				$msg = $row["fullname"] . " has deleted the item \"$itemdesc\" from their list.";
			}
			$msg .= "\r\n\r\nYou are receiving this message because you are subscribed to their updates.  You will not receive another message for their updates for the next " . $opt["notify_threshold_minutes"] . " minutes.";
		}
		sendMessage($publisher, $row["subscriber"], $msg, $dbh, $opt);

		// stamp the subscription.
		$stmt2 = $dbh->prepare("UPDATE {$opt["table_prefix"]}subscriptions SET last_notified = NOW() WHERE publisher = ? AND subscriber = ?");
		$stmt2->bindParam(1, $publisher, PDO::PARAM_INT);
		$stmt2->bindParam(2, $row["subscriber"], PDO::PARAM_INT);
		$stmt2->execute();
	}
}

function sendMessage($sender, $recipient, $message, $dbh, $opt) {
	$stmt = $dbh->prepare("INSERT INTO {$opt["table_prefix"]}messages(sender,recipient,message,created) VALUES(?, ?, ?, ?)");
	$stmt->bindParam(1, $sender, PDO::PARAM_INT);
	$stmt->bindParam(2, $recipient, PDO::PARAM_INT);
	$stmt->bindParam(3, $message, PDO::PARAM_STR);
	$stmt->bindValue(4, date("Y-m-d"), PDO::PARAM_STR);
	$stmt->execute();

	// determine if e-mail must be sent.
	$stmt = $dbh->prepare("SELECT ur.email_msgs, ur.email AS remail, us.fullname, us.email AS semail FROM {$opt["table_prefix"]}users ur " .
			"INNER JOIN {$opt["table_prefix"]}users us ON us.userid = ? " .
			"WHERE ur.userid = ?");
	$stmt->bindParam(1, $sender, PDO::PARAM_INT);
	$stmt->bindParam(2, $recipient, PDO::PARAM_INT);
	$stmt->execute();
	if ($row = $stmt->fetch()) {
		// only mail valid addresses, and only put a validated address in the
		// Reply-To header (prevents header injection via a user's profile).
		if ($row["email_msgs"] == 1 && isValidEmail($row["remail"])) {
			$fullname = stripNewlines($row["fullname"]);
			$headers = "From: {$opt["email_from"]}\r\n";
			if (isValidEmail($row["semail"])) {
				$headers .= "Reply-To: " . $row["semail"] . "\r\n";
			}
			$headers .= "X-Mailer: {$opt["email_xmailer"]}\r\n";
			mail(
				$row["remail"],
				"Gift Registry message from " . $fullname,
				$fullname . " <" . $row["semail"] . "> sends:\r\n" . $message,
				$headers
			) or die("Mail not accepted for " . $row["remail"]);
		}
	}
	else {
		die("recipient doesn't exist");
	}
}

function generatePassword($opt) {
	//* borrowed from hitech-password.php - a PHP Message board script
	//* (c) Hitech Scripts 2003
	//* For more information, visit http://www.hitech-scripts.com
	//* modified for phpgiftreg by Chris Clonch
	// uses random_int() (CSPRNG) so generated passwords aren't predictable.
	$chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
	$newstring = "";
	for ($i = 0; $i < (int) $opt["password_length"]; $i++) {
		$newstring .= $chars[random_int(0, strlen($chars) - 1)];
	}
	return $newstring;
}

/* Hash a plaintext password for storage. */
function hashPassword($password) {
	return password_hash($password, PASSWORD_DEFAULT);
}

/* Check a plaintext password against a stored value.
	Accepts password_hash() hashes as well as legacy values created with the
	old "password_hasher" option (MD5, SHA1 or plaintext), so existing users
	can still log in.  $needsRehash is set to true when the caller should
	re-store the password with hashPassword(). */
function verifyPassword($password, $stored, $opt, &$needsRehash) {
	$needsRehash = false;
	if ($password === "" || $stored === null || $stored === "") {
		return false;
	}

	if (!empty(password_get_info($stored)["algo"])) {
		if (!password_verify($password, $stored)) {
			return false;
		}
		$needsRehash = password_needs_rehash($stored, PASSWORD_DEFAULT);
		return true;
	}

	// legacy hash from the old MySQL-function based scheme.
	$hasher = isset($opt["password_hasher"]) ? strtoupper($opt["password_hasher"]) : "";
	switch ($hasher) {
		case "MD5":
			$ok = hash_equals(strtolower($stored), md5($password));
			break;
		case "SHA1":
			$ok = hash_equals(strtolower($stored), sha1($password));
			break;
		case "":
			$ok = hash_equals($stored, $password);
			break;
		default:
			error_log("phpgiftreg: unsupported legacy password_hasher '$hasher'");
			$ok = false;
	}
	$needsRehash = $ok;
	return $ok;
}

function formatPrice($price, $opt) {
	if ($price == 0.0 && $opt["hide_zero_price"])
		return "&nbsp;";
	else
		return $opt["currency_symbol"] . number_format($price,2,".",",");
}

function stampUser($userid, $dbh, $opt) {
	$stmt = $dbh->prepare("UPDATE {$opt["table_prefix"]}users SET list_stamp = NOW() WHERE userid = ?");
	$stmt->bindParam(1, $userid, PDO::PARAM_INT);
	$stmt->execute();
}

function deleteImageForItem($itemid, $dbh, $opt) {
	$stmt = $dbh->prepare("SELECT image_filename FROM {$opt["table_prefix"]}items WHERE itemid = ?");
	$stmt->bindParam(1, $itemid, PDO::PARAM_INT);
	$stmt->execute();
	if ($row = $stmt->fetch()) {
		if ($row["image_filename"] != "") {
			// basename() so a stored filename can never point outside the image dir.
			$path = dirname(__FILE__) . "/../" . $opt["image_subdir"] . "/" . basename($row["image_filename"]);
			if (is_file($path)) {
				unlink($path);
			}
		}

		$stmt = $dbh->prepare("UPDATE {$opt["table_prefix"]}items SET image_filename = NULL WHERE itemid = ?");
		$stmt->bindParam(1, $itemid, PDO::PARAM_INT);
		$stmt->execute();
	}
}

/* Validate and store an uploaded image.  Returns the stored base filename,
	or false (with $error set) if the upload is missing or not an image. */
function saveUploadedImage($field, $opt, &$error) {
	$allowed = array(
		IMAGETYPE_JPEG => "jpg",
		IMAGETYPE_PNG => "png",
		IMAGETYPE_GIF => "gif",
		IMAGETYPE_WEBP => "webp"
	);
	if (!isset($_FILES[$field]["error"]) || !is_int($_FILES[$field]["error"]) ||
			$_FILES[$field]["error"] !== UPLOAD_ERR_OK || !is_uploaded_file($_FILES[$field]["tmp_name"])) {
		$error = "Please choose an image file to upload.";
		return false;
	}
	$info = @getimagesize($_FILES[$field]["tmp_name"]);
	if ($info === false || !isset($allowed[$info[2]])) {
		$error = "Only JPEG, PNG, GIF or WebP images can be uploaded.";
		return false;
	}
	$name = bin2hex(random_bytes(16)) . "." . $allowed[$info[2]];
	$dir = dirname(__FILE__) . "/../" . $opt["image_subdir"];
	if (!move_uploaded_file($_FILES[$field]["tmp_name"], $dir . "/" . $name)) {
		$error = "The image could not be saved.";
		return false;
	}
	return $name;
}

function fixForJavaScript($s) {
	$s = htmlentities($s);
	$s = str_replace("'","\\'",$s);
	$s = str_replace("\r\n","<br />",$s);
	$s = str_replace("\n","<br />",$s);
	return $s;
}
?>
