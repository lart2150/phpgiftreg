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

{block name=title}Update Profile{/block}

{block name=content}
	<h1 class="page-title mb-3">Profile</h1>
	<div class="row g-4">
		<div class="col-lg-7">
			<form name="profileform" id="profileform" action="profile.php" method="POST" class="card gr-card">
				<input type="hidden" name="csrf" value="{$csrf}">
				<input type="hidden" name="action" value="save">
				<div class="card-header">
					<h2 class="card-title"><i class="bi bi-person-circle"></i>Update Profile</h2>
				</div>
				<div class="card-body">
					<div class="mb-3">
						<label class="form-label" for="fullname">Full name</label>
						<input type="text" id="fullname" name="fullname" class="form-control" value="{$fullname}" autocomplete="name">
					</div>
					<div class="mb-3">
						<label class="form-label" for="email">E-mail address</label>
						<input type="email" id="email" name="email" class="form-control" value="{$email}" autocomplete="email">
					</div>
					<div class="form-check form-switch mb-3">
						<input class="form-check-input" type="checkbox" role="switch" id="email_msgs" name="email_msgs" {if $email_msgs}checked{/if}>
						<label class="form-check-label" for="email_msgs">E-mail me a copy of every message</label>
					</div>
					<div>
						<label class="form-label" for="comment">Comments / shipping address / etc. <span class="gr-subtle">(optional)</span></label>
						<textarea id="comment" name="comment" rows="4" class="form-control">{$comment}</textarea>
					</div>
				</div>
				<div class="card-footer bg-transparent d-flex gap-2">
					<button type="submit" class="btn btn-primary">Update Profile</button>
					<a class="btn btn-outline-secondary" href="index.php">Cancel</a>
				</div>
			</form>
		</div>

		<div class="col-lg-5">
			<form name="changepwdform" id="changepwdform" action="profile.php" method="POST" class="card gr-card">
				<input type="hidden" name="csrf" value="{$csrf}">
				<input type="hidden" name="action" value="changepwd">
				<div class="card-header">
					<h2 class="card-title"><i class="bi bi-key"></i>Change Password</h2>
				</div>
				<div class="card-body">
					<div class="mb-3">
						<label class="form-label" for="newpwd">New password</label>
						<input type="password" id="newpwd" name="newpwd" class="form-control" autocomplete="new-password">
					</div>
					<div>
						<label class="form-label" for="confpwd">Confirm password</label>
						<input type="password" id="confpwd" name="confpwd" class="form-control" autocomplete="new-password">
					</div>
				</div>
				<div class="card-footer bg-transparent d-flex gap-2">
					<button type="submit" class="btn btn-primary">Change Password</button>
					<a class="btn btn-outline-secondary" href="index.php">Cancel</a>
				</div>
			</form>
		</div>
	</div>
{/block}

{block name=scripts}
	<script>
		$(function() {
			$("#changepwdform").validate({
				rules: {
					newpwd: { required: true, maxlength: 50 },
					confpwd: { required: true, maxlength: 50, equalTo: "#newpwd" }
				},
				messages: {
					newpwd: {
						required: "Password is required.",
						maxlength: "Password must be 50 characters or less."
					},
					confpwd: {
						required: "Confirmation is required.",
						maxlength: "Confirmation must be 50 characters or less.",
						equalTo: "Passwords don't match."
					}
				}
			});
			$("#profileform").validate({
				rules: {
					fullname: { required: true, maxlength: 50 },
					email: { required: true, maxlength: 255, email: true }
				},
				messages: {
					fullname: {
						required: "Full name is required.",
						maxlength: "Full name must be 50 characters or less."
					},
					email: {
						required: "E-mail address is required.",
						maxlength: "E-mail address must be 255 characters or less.",
						email: "E-mail address must be a valid address."
					}
				}
			});
		});
	</script>
{/block}
