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
{extends file='layout.tpl'}

{block name=title}Choose a New Password{/block}
{block name=bodyclass}auth-body{/block}
{block name=navbar}{/block}
{block name=main}auth-wrap{/block}
{block name=flash}{/block}

{block name=content}
	<div class="auth-brand">
		<i class="bi bi-gift-fill"></i>
		<h1>Gift Registry</h1>
	</div>
	<div class="card gr-card">
		<div class="card-body p-4">
			{if !$valid}
				<h2 class="h4"><i class="bi bi-exclamation-triangle text-accent me-1"></i> Link not valid</h2>
				<p>This password reset link is invalid, has already been used, or has expired.</p>
				<div class="d-flex gap-2">
					<a class="btn btn-primary" href="forgot.php">Request a new link</a>
					<a class="btn btn-outline-secondary" href="login.php">Back to login</a>
				</div>
			{else}
				<h2 class="h4 mb-3">New password for {$username}</h2>
				<form name="resetform" id="resetform" method="post" action="reset.php">
					<input type="hidden" name="action" value="reset">
					<input type="hidden" name="token" value="{$token}">
					{if isset($error)}
						<div class="alert alert-danger">{$error}</div>
					{/if}
					<div class="mb-3">
						<label class="form-label" for="newpwd">New password</label>
						<input id="newpwd" name="newpwd" type="password" class="form-control" autocomplete="new-password">
					</div>
					<div class="mb-3">
						<label class="form-label" for="confirmpwd">Confirm password</label>
						<input id="confirmpwd" name="confirmpwd" type="password" class="form-control" autocomplete="new-password">
					</div>
					<div class="d-flex gap-2 mt-4">
						<button type="submit" class="btn btn-primary">Change Password</button>
						<a class="btn btn-outline-secondary" href="login.php">Cancel</a>
					</div>
				</form>
			{/if}
		</div>
	</div>
{/block}

{block name=scripts}
	<script>
		$(function() {
			$("#resetform").validate({
				rules: {
					newpwd: { required: true },
					confirmpwd: { required: true, equalTo: "#newpwd" }
				},
				messages: {
					newpwd: { required: "A new password is required." },
					confirmpwd: {
						required: "Please type the new password again.",
						equalTo: "The passwords don't match."
					}
				}
			});
		});
	</script>
{/block}
