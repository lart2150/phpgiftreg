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

{block name=title}Manage Families{/block}

{block name=content}
	<div class="d-flex flex-wrap align-items-center gap-2 mb-3">
		<h1 class="page-title me-auto">Families</h1>
		<a class="btn btn-sm btn-primary" href="families.php#familyform"><i class="bi bi-plus-lg"></i> Add family</a>
	</div>

	{if $opt.show_helptext}
		<details class="gr-tips mb-4">
			<summary><i class="bi bi-lightbulb me-1"></i> Tips</summary>
			<p class="small mb-1">
				Here you can specify families that will use your gift registry. Members may belong to one or more family circles.
				After adding a new family, click Edit to add members to it.
			</p>
		</details>
	{/if}

	<div class="row g-4">
		<div class="col-lg-6">
			<section class="card gr-card stack-host">
				<div class="card-body p-0 p-md-2">
					<table class="table gr-table table-hover table-stack">
						<thead>
							<tr>
								<th>Family</th>
								<th># Members</th>
								<th><span class="visually-hidden">Actions</span></th>
							</tr>
						</thead>
						<tbody>
							{foreach from=$families item=row}
								<tr>
									<td class="cell-title">{$row.familyname}</td>
									<td data-label="Members">{$row.members}</td>
									<td class="cell-actions">
										<a class="btn btn-icon btn-sm btn-outline-secondary" href="families.php?csrf={$csrf}&action=edit&familyid={$row.familyid}#familyform" title="Edit Family"><i class="bi bi-pencil"></i><span class="act-label">Edit</span></a>
										<a class="btn btn-icon btn-sm btn-outline-danger" href="families.php?csrf={$csrf}&action=delete&familyid={$row.familyid}" title="Delete Family" data-confirm="Are you sure you want to delete the family &quot;{$row.familyname}&quot;?"><i class="bi bi-trash"></i><span class="act-label">Delete</span></a>
									</td>
								</tr>
							{foreachelse}
								<tr class="row-empty"><td colspan="3" class="cell-empty gr-empty"><i class="bi bi-house-heart"></i>No families yet.</td></tr>
							{/foreach}
						</tbody>
					</table>
				</div>
			</section>
		</div>

		<div class="col-lg-6" id="familyform">
			<form name="theform" id="theform" method="get" action="families.php" class="card gr-card mb-4">
				<input type="hidden" name="csrf" value="{$csrf}">
				{if $action == "edit" || (isset($haserror) && $action == "update")}
					<input type="hidden" name="familyid" value="{$familyid}">
					<input type="hidden" name="action" value="update">
				{elseif $action == "" || (isset($haserror) && $action == "insert")}
					<input type="hidden" name="action" value="insert">
				{/if}
				<div class="card-header">
					<h2 class="card-title"><i class="bi bi-house-heart"></i>{if $action == "edit" || $action == "update"}Edit family '{$familyname}'{else}Add Family{/if}</h2>
				</div>
				<div class="card-body">
					<label class="form-label" for="familyname">Family name</label>
					<input id="familyname" name="familyname" type="text" class="form-control {if isset($familyname_error)}is-invalid{/if}" value="{$familyname}" maxlength="255">
					{if isset($familyname_error)}<div class="invalid-feedback">{$familyname_error}</div>{/if}
				</div>
				<div class="card-footer bg-transparent d-flex gap-2">
					<button type="submit" class="btn btn-primary">{if $action == "" || $action == "insert" || $action == "update"}Add{else}Update{/if}</button>
					<a class="btn btn-outline-secondary" href="families.php">Cancel</a>
				</div>
			</form>

			{if $action == "edit"}
				<form name="membership" method="get" action="families.php" class="card gr-card">
					<input type="hidden" name="csrf" value="{$csrf}">
					<input type="hidden" name="familyid" value="{$familyid}">
					<input type="hidden" name="action" value="members">
					<div class="card-header">
						<h2 class="card-title"><i class="bi bi-people"></i>Members of '{$familyname}'</h2>
					</div>
					<div class="card-body">
						{* Checkboxes instead of a ctrl-click multi-select: usable on touch screens. *}
						<div class="border rounded p-2" style="max-height: 20rem; overflow-y: auto;">
							{foreach from=$nonmembers item=row}
								<div class="form-check">
									<input class="form-check-input" type="checkbox" name="members[]" value="{$row.userid}" id="member-{$row.userid}" {if $row.familyid != ''}checked{/if}>
									<label class="form-check-label" for="member-{$row.userid}">{$row.fullname}</label>
								</div>
							{/foreach}
						</div>
					</div>
					<div class="card-footer bg-transparent d-flex gap-2">
						<button type="submit" class="btn btn-primary">Save</button>
						<a class="btn btn-outline-secondary" href="families.php">Cancel</a>
					</div>
				</form>
			{/if}
		</div>
	</div>
{/block}

{block name=scripts}
	<script>
		$(function() {
			$("#theform").validate({
				rules: {
					familyname: { required: true, maxlength: 255 }
				},
				messages: {
					familyname: {
						required: "Family name is required.",
						maxlength: "Family name must be 255 characters or less."
					}
				}
			});
		});
	</script>
{/block}
