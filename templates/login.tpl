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

{block name=title}Login{/block}
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
			<form name="loginform" id="loginform" method="post" action="login.php">
				{if isset($error)}
					<div class="alert alert-danger">{$error}</div>
				{elseif isset($username)}
					<div class="alert alert-danger">Bad login.</div>
				{elseif isset($message)}
					<div class="alert alert-success">{$message}</div>
				{/if}
				<div class="mb-3">
					<label class="form-label" for="username">Username</label>
					<input id="username" name="username" type="text" class="form-control form-control-lg" placeholder="username" autocomplete="username" autocapitalize="none" autofocus>
				</div>
				<div class="mb-4">
					<label class="form-label" for="password">Password</label>
					<input id="password" name="password" type="password" class="form-control form-control-lg" placeholder="password" autocomplete="current-password">
				</div>
				<button type="submit" class="btn btn-primary btn-lg w-100">Login</button>
			</form>
		</div>
	</div>
	<div class="d-flex justify-content-between mt-3 px-1">
		<a href="signup.php">Need an account?</a>
		<a href="forgot.php">Forgot your password?</a>
	</div>
{/block}

{block name=scripts}
	<script>
		$(function() {
			$("#loginform").validate({
				rules: {
					username: { required: true },
					password: { required: true }
				},
				messages: {
					username: { required: "Username is required." },
					password: { required: "Password is required." }
				}
			});
		});
	</script>
{/block}
