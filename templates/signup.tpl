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

{block name=title}Sign Up{/block}
{block name=bodyclass}auth-body{/block}
{block name=navbar}{/block}
{block name=main}auth-wrap wide{/block}
{block name=flash}{/block}

{block name=content}
	<div class="auth-brand">
		<i class="bi bi-gift-fill"></i>
		<h1>Gift Registry</h1>
	</div>

	{if isset($error)}
		<div class="alert alert-danger">{$error}</div>
	{/if}

	{if isset($action) && $action == "signup" && !isset($error)}
		<div class="card gr-card">
			<div class="card-body p-4">
				<h2 class="h4"><i class="bi bi-check-circle text-evergreen me-1"></i> Thank you for signing up</h2>
				{if $opt.newuser_requires_approval}
					<p>The administrators have been informed of your request and you will receive an e-mail once they've made a decision.</p>
				{else}
					<p>Shortly, you will receive an e-mail with your initial password.</p>
				{/if}
				<a class="btn btn-primary" href="login.php">Go to login</a>
			</div>
		</div>
	{else}
		<div class="card gr-card">
			<div class="card-body p-4">
				<h2 class="h4 mb-2">Sign up</h2>
				<p class="gr-subtle small">
					{if $opt.newuser_requires_approval}
						The list administrators will be notified of your request by e-mail and will approve or decline it.
						If the e-mail address you supply is valid, you will be notified once a decision is made.
					{else}
						If the e-mail address you supply is valid, you will shortly receive an e-mail with your initial password.
					{/if}
				</p>
				<form name="signupform" id="signupform" method="post" action="signup.php">
					<input type="hidden" name="action" value="signup">
					<div class="mb-3">
						<label class="form-label" for="username">Username</label>
						<input id="username" name="username" type="text" class="form-control" value="{$username}" placeholder="Username" autocomplete="username" autocapitalize="none">
					</div>
					<div class="mb-3">
						<label class="form-label" for="fullname">Full name</label>
						<input id="fullname" name="fullname" type="text" class="form-control" value="{$fullname}" placeholder="Full name" autocomplete="name">
					</div>
					<div class="mb-3">
						<label class="form-label" for="email">E-mail address</label>
						<input id="email" name="email" type="email" class="form-control" value="{$email}" placeholder="you@somewhere.com" autocomplete="email">
					</div>
					{if $familycount > 1}
						<div class="mb-3">
							<label class="form-label" for="familyid">Family</label>
							<select id="familyid" name="familyid" class="form-select">
								<option value="">(select one)</option>
								{foreach from=$families item=row}
									<option value="{$row.familyid}">{$row.familyname}</option>
								{/foreach}
							</select>
						</div>
					{else}
						<input type="hidden" name="familyid" value="{$familyid}">
					{/if}
					<div class="d-flex gap-2 mt-4">
						<button type="submit" class="btn btn-primary">Submit</button>
						<a class="btn btn-outline-secondary" href="login.php">Cancel</a>
					</div>
				</form>
			</div>
		</div>
	{/if}
{/block}

{block name=scripts}
	<script>
		$(function() {
			$("#signupform").validate({
				rules: {
					username: { required: true, maxlength: 20 },
					fullname: { required: true, maxlength: 50 },
					email: { required: true, email: true, maxlength: 255 },
					familyid: { required: true }
				},
				messages: {
					username: {
						required: "A username is required.",
						maxlength: "Username must be 20 characters or less."
					},
					fullname: {
						required: "Your full name is required.",
						maxlength: "Your full name must be 50 characters or less."
					},
					email: "A valid e-mail address is required.",
					familyid: "Please select a family."
				}
			});
		});
	</script>
{/block}
