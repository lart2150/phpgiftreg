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

{block name=title}Manage Ranks{/block}

{block name=content}
	<div class="d-flex flex-wrap align-items-center gap-2 mb-3">
		<h1 class="page-title me-auto">Ranks</h1>
		<a class="btn btn-sm btn-primary" href="ranks.php#rankform"><i class="bi bi-plus-lg"></i> Add rank</a>
	</div>

	<section class="card gr-card stack-host mb-4">
		<div class="card-body p-0 p-md-2">
			<table class="table gr-table table-hover table-stack">
				<thead>
					<tr>
						<th>Title</th>
						<th>Rendered HTML</th>
						<th>Rank Order</th>
						<th><span class="visually-hidden">Actions</span></th>
					</tr>
				</thead>
				<tbody>
					{foreach from=$ranks item=row}
						<tr>
							<td class="cell-title">{$row.title}</td>
							<td data-label="Rendered" class="rank text-nowrap"><span>{$row.rendered nofilter}</span></td>
							<td data-label="Order">{$row.rankorder}</td>
							<td class="cell-actions">
								<a class="btn btn-icon btn-sm btn-outline-secondary" href="ranks.php?csrf={$csrf}&action=promote&ranking={$row.ranking}&rankorder={$row.rankorder}" title="Promote"><i class="bi bi-arrow-up"></i><span class="act-label">Up</span></a>
								<a class="btn btn-icon btn-sm btn-outline-secondary" href="ranks.php?csrf={$csrf}&action=demote&ranking={$row.ranking}&rankorder={$row.rankorder}" title="Demote"><i class="bi bi-arrow-down"></i><span class="act-label">Down</span></a>
								<a class="btn btn-icon btn-sm btn-outline-secondary" href="ranks.php?csrf={$csrf}&action=edit&ranking={$row.ranking}#rankform" title="Edit Rank"><i class="bi bi-pencil"></i><span class="act-label">Edit</span></a>
								<a class="btn btn-icon btn-sm btn-outline-danger" href="ranks.php?csrf={$csrf}&action=delete&ranking={$row.ranking}" title="Delete Rank" data-confirm="Are you sure you want to delete the rank &quot;{$row.title}&quot;?"><i class="bi bi-trash"></i><span class="act-label">Delete</span></a>
							</td>
						</tr>
					{/foreach}
				</tbody>
			</table>
		</div>
	</section>

	<div class="row justify-content-center">
		<div class="col-lg-8">
			<form name="theform" id="rankform" method="get" action="ranks.php" class="card gr-card">
				<input type="hidden" name="csrf" value="{$csrf}">
				{if $action == "edit" || (isset($haserror) && $action == "update")}
					<input type="hidden" name="ranking" value="{$ranking}">
					<input type="hidden" name="action" value="update">
				{elseif $action == "" || (isset($haserror) && $action == "insert")}
					<input type="hidden" name="action" value="insert">
				{/if}
				<div class="card-header">
					<h2 class="card-title"><i class="bi bi-star"></i>{if $action == "edit"}Edit Rank '{$title}'{else}Add Rank{/if}</h2>
				</div>
				<div class="card-body">
					<div class="mb-3">
						<label class="form-label" for="title">Title</label>
						<input id="title" name="title" class="form-control {if isset($title_error)}is-invalid{/if}" type="text" value="{$title}" maxlength="255">
						{if isset($title_error)}<div class="invalid-feedback">{$title_error}</div>{/if}
					</div>
					<div>
						<label class="form-label" for="rendered">HTML</label>
						<textarea id="rendered" name="rendered" class="form-control font-monospace small {if isset($rendered_error)}is-invalid{/if}" rows="4">{$rendered}</textarea>
						{if isset($rendered_error)}<div class="invalid-feedback">{$rendered_error}</div>{/if}
					</div>
				</div>
				<div class="card-footer bg-transparent d-flex gap-2">
					<button type="submit" class="btn btn-primary">{if $action == "" || $action == "insert"}Add{else}Update{/if}</button>
					<a class="btn btn-outline-secondary" href="ranks.php">Cancel</a>
				</div>
			</form>
		</div>
	</div>
{/block}

{block name=scripts}
	<script>
		$(function() {
			$("#rankform").validate({
				rules: {
					title: { required: true, maxlength: 50 },
					rendered: { required: true, maxlength: 255 }
				},
				messages: {
					title: {
						required: "A title is required.",
						maxlength: "Title must be 50 characters or less."
					},
					rendered: {
						required: "HTML is required.",
						maxlength: "HTML must be 255 characters or less."
					}
				}
			});
		});
	</script>
{/block}
