<?php
/// This program is free software; you can redistribute it and/or modify
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

if (postParam("action") == "forgot") {
	$username = postParam("username");

	try {
		$dbh = $smarty->dbh();
		$stmt = $dbh->prepare("SELECT userid, email FROM {$opt["table_prefix"]}users WHERE username = ? AND approved = 1");
		$stmt->bindParam(1, $username, PDO::PARAM_STR);
		$stmt->execute();
		$row = $stmt->fetch();

		if ($row && isValidEmail($row["email"])) {
			// at most one reset e-mail per account every 5 minutes.
			$stmt = $dbh->prepare("SELECT COUNT(*) FROM {$opt["table_prefix"]}password_resets WHERE userid = ? AND created > NOW() - INTERVAL 5 MINUTE");
			$stmt->bindValue(1, (int) $row["userid"], PDO::PARAM_INT);
			$stmt->execute();
			if ($stmt->fetchColumn() == 0) {
				// the password is NOT changed here; the user picks a new one via the
				// e-mailed link.  only a hash of the token is stored.
				$token = bin2hex(random_bytes(32));
				$stmt = $dbh->prepare("REPLACE INTO {$opt["table_prefix"]}password_resets(userid, token_hash, created, expires) VALUES(?, ?, NOW(), NOW() + INTERVAL 1 HOUR)");
				$stmt->bindValue(1, (int) $row["userid"], PDO::PARAM_INT);
				$stmt->bindValue(2, hash("sha256", $token), PDO::PARAM_STR);
				$stmt->execute();

				$sent = mail(
					$row["email"],
					"Gift Registry password reset",
					"Someone (hopefully you) asked to reset the password for the Gift Registry account '" . stripNewlines($username) . "'.

" .
						"To choose a new password, open this link within the next hour:
" .
						getSiteUrl("reset.php?token=" . $token, $opt) . "

" .
						"If you didn't ask for this, ignore this e-mail; your password has not been changed.",
					"From: {$opt["email_from"]}
Reply-To: {$opt["email_reply_to"]}
X-Mailer: {$opt["email_xmailer"]}
"
				);
				if (!$sent) {
					error_log("phpgiftreg: password reset mail for userid {$row["userid"]} was not accepted");
				}
			}
		}
	}
	catch (PDOException $e) {
		failWithError($e);
	}

	// same response whether or not the account exists, so the form can't be
	// used to discover usernames.
	$smarty->assign('action', 'forgot');
	$smarty->assign('error', '');
	$smarty->display('forgot.tpl');
}
else {
	$smarty->display('forgot.tpl');
}
?>
