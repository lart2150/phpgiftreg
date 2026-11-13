{*
This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*}

<!DOCTYPE html>
<html lang="en">
<head>
	<title>Gift Registry - Choose a New Password</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link href="bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<link href="bootstrap/css/bootstrap-responsive.css" rel="stylesheet">
	<script src="js/jquery-3.7.1.min.js"></script>
	<script src="bootstrap/js/bootstrap.min.js"></script>
	<script src="js/jquery.validate.min.js"></script>
	<script src="js/giftreg.js"></script>

	<script language="JavaScript" type="text/javascript">
		$(document).ready(function() {
			$("#resetform").validate({
				highlight: validate_highlight,
				success: validate_success,
				rules: {
					newpwd: {
						required: true
					},
					confirmpwd: {
						required: true,
						equalTo: "#newpwd"
					}
				},
				messages: {
					newpwd: {
						required: "A new password is required."
					},
					confirmpwd: {
						required: "Please type the new password again.",
						equalTo: "The passwords don't match."
					}
				}
			});
		});
	</script>
</head>
<body>
	<div class="container" style="padding-top: 30px;">
		<div class="row">
			<div class="span12">
	{if !$valid}
				<div class="well">
					<p>This password reset link is invalid, has already been used, or has expired.</p>
					<p><a href="forgot.php">Request a new link</a> or go back to <a href="login.php">login</a>.</p>
				</div>
	{else}
				<form name="resetform" id="resetform" method="post" action="reset.php" class="well form-horizontal">
					<input type="hidden" name="action" value="reset">
					<input type="hidden" name="token" value="{$token}">
					<fieldset>
						<legend>Choose a New Password for {$username}</legend>
						{if isset($error)}
							<div class="alert alert-error">{$error}</div>
						{/if}
						<div class="control-group">
							<label class="control-label" for="newpwd">New password</label>
							<div class="controls">
								<input id="newpwd" name="newpwd" type="password" class="input-xlarge" autocomplete="new-password">
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="confirmpwd">Confirm password</label>
							<div class="controls">
								<input id="confirmpwd" name="confirmpwd" type="password" class="input-xlarge" autocomplete="new-password">
							</div>
						</div>
						<div class="form-actions">
							<button type="submit" class="btn btn-primary">Change Password</button>
							<button type="button" class="btn" onClick="document.location.href='login.php';">Cancel</button>
						</div>
					</fieldset>
				</form>
	{/if}
			</div>
		</div>
	</div>
</body>
</html>
