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

{block name=title}Manage Users{/block}

{block name=content}
	<div class="d-flex flex-wrap align-items-center gap-2 mb-3">
		<h1 class="page-title me-auto">Users</h1>
		<a class="btn btn-sm btn-primary" href="users.php#userform"><i class="bi bi-person-plus"></i> Add user</a>
	</div>

	<section class="card gr-card stack-host mb-4">
		<div class="card-body p-0 p-md-2">
			<table class="table gr-table table-hover table-stack">
				<thead>
					<tr>
						<th>Full name</th>
						<th>Username</th>
						<th>E-mail</th>
						<th>E-mail messages?</th>
						<th>Approved?</th>
						<th>Admin?</th>
						<th><span class="visually-hidden">Actions</span></th>
					</tr>
				</thead>
				<tbody>
					{foreach from=$users item=row}
						<tr>
							<td class="cell-title">{$row.fullname}</td>
							<td data-label="Username">{$row.username}</td>
							<td data-label="E-mail" class="text-break">{$row.email}</td>
							<td data-label="E-mail msgs">{if $row.email_msgs}Yes{else}No{/if}</td>
							<td data-label="Approved">{if $row.approved}<span class="badge status-badge badge-evergreen">Yes</span>{else}<span class="badge status-badge text-bg-secondary">No</span>{/if}</td>
							<td data-label="Admin">{if $row.admin}<span class="badge status-badge badge-accent">Admin</span>{else}No{/if}</td>
							<td class="cell-actions">
								<a class="btn btn-icon btn-sm btn-outline-secondary" href="users.php?csrf={$csrf}&action=edit&userid={$row.userid}#userform" title="Edit User"><i class="bi bi-pencil"></i><span class="act-label">Edit</span></a>
								{if $row.email != ''}
									<a class="btn btn-icon btn-sm btn-outline-secondary" href="users.php?csrf={$csrf}&action=reset&userid={$row.userid}" title="Reset Password"><i class="bi bi-key"></i><span class="act-label">Reset password</span></a>
								{/if}
								<a class="btn btn-icon btn-sm btn-outline-danger" href="users.php?csrf={$csrf}&action=delete&userid={$row.userid}" title="Delete User" data-confirm="Are you sure you want to delete {$row.fullname}?"><i class="bi bi-trash"></i><span class="act-label">Delete</span></a>
							</td>
						</tr>
					{/foreach}
				</tbody>
			</table>
		</div>
	</section>

	<div class="row justify-content-center">
		<div class="col-lg-8">
			<form name="theform" id="userform" method="get" action="users.php" class="card gr-card">
				<input type="hidden" name="csrf" value="{$csrf}">
				{if $action == "edit" || (isset($haserror) && $action == "update")}
					<input type="hidden" name="userid" value="{$edituserid}">
					<input type="hidden" name="action" value="update">
				{elseif $action == "" || (isset($haserror) && $action == "insert")}
					<input type="hidden" name="action" value="insert">
				{/if}
				<div class="card-header">
					<h2 class="card-title"><i class="bi bi-person-gear"></i>{if $action == "edit" || $action == "update"}Edit User{else}Add User{/if}</h2>
				</div>
				<div class="card-body">
					<div class="row g-3">
						<div class="col-md-6">
							<label class="form-label" for="username">Username</label>
							<input id="username" name="username" type="text" class="form-control {if isset($username_error)}is-invalid{/if}" value="{$username}" maxlength="255" autocapitalize="none">
							{if isset($username_error)}<div class="invalid-feedback">{$username_error}</div>{/if}
						</div>
						<div class="col-md-6">
							<label class="form-label" for="fullname">Full name</label>
							<input id="fullname" name="fullname" type="text" class="form-control {if isset($fullname_error)}is-invalid{/if}" value="{$fullname}" maxlength="255">
							{if isset($fullname_error)}<div class="invalid-feedback">{$fullname_error}</div>{/if}
						</div>
						<div class="col-12">
							<label class="form-label" for="email">E-mail address</label>
							<input id="email" name="email" type="email" class="form-control {if isset($email_error)}is-invalid{/if}" value="{$email}" maxlength="255">
							{if isset($email_error)}<div class="invalid-feedback">{$email_error}</div>{/if}
						</div>
						<div class="col-12 d-flex flex-wrap gap-4">
							<div class="form-check form-switch">
								<input class="form-check-input" type="checkbox" role="switch" name="email_msgs" id="email_msgs" {if $email_msgs}checked{/if}>
								<label class="form-check-label" for="email_msgs">E-mail messages</label>
							</div>
							<div class="form-check form-switch">
								<input class="form-check-input" type="checkbox" role="switch" name="approved" id="approved" {if $approved}checked{/if}>
								<label class="form-check-label" for="approved">Approved</label>
							</div>
							<div class="form-check form-switch">
								<input class="form-check-input" type="checkbox" role="switch" name="admin" id="admin" {if $userisadmin}checked{/if}>
								<label class="form-check-label" for="admin">Administrator</label>
							</div>
						</div>
					</div>
				</div>
				<div class="card-footer bg-transparent d-flex gap-2">
					<button type="submit" class="btn btn-primary">{if $action == "" || $action == "insert"}Add{else}Update{/if}</button>
					<a class="btn btn-outline-secondary" href="users.php">Cancel</a>
				</div>
			</form>
		</div>
	</div>
{/block}

{block name=scripts}
	<script>
		$(function() {
			$("#userform").validate({
				rules: {
					username: { required: true, maxlength: 20 },
					fullname: { required: true, maxlength: 50 },
					email: { required: true, maxlength: 255, email: true }
				},
				messages: {
					username: {
						required: "Username is required.",
						maxlength: "Username must be 20 characters or less."
					},
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
