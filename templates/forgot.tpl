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

{block name=title}Forgot Password{/block}
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
			{if isset($action) && $action == "forgot" && $error == ""}
				<h2 class="h4"><i class="bi bi-envelope-check text-evergreen me-1"></i> Check your e-mail</h2>
				<p>If that username has an e-mail address on file, you'll shortly receive an e-mail with a link to choose a new password. The link works for one hour.</p>
				<p class="mb-0">Your current password still works until you choose a new one.</p>
				<a class="btn btn-primary mt-3" href="login.php">Back to login</a>
			{else}
				<h2 class="h4 mb-2">Reset your password</h2>
				<p class="gr-subtle small">Supply your username and we'll e-mail a link to choose a new password to the address on your account.</p>
				<form name="forgotform" id="forgotform" method="post" action="forgot.php">
					<input type="hidden" name="action" value="forgot">
					<div class="mb-3">
						<label class="form-label" for="username">Username</label>
						<input id="username" name="username" type="text" class="form-control {if isset($error) && $error != ''}is-invalid{/if}" value="{$username}" autocomplete="username" autocapitalize="none">
						{if isset($error) && $error != ''}
							<div class="invalid-feedback">{$error}</div>
						{/if}
					</div>
					<div class="d-flex gap-2 mt-4">
						<button type="submit" class="btn btn-primary">Submit</button>
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
			$("#forgotform").validate({
				rules: { username: { required: true } },
				messages: { username: { required: "Username is required." } }
			});
		});
	</script>
{/block}
