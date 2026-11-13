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

{block name=title}Manage Categories{/block}

{block name=content}
	<div class="d-flex flex-wrap align-items-center gap-2 mb-3">
		<h1 class="page-title me-auto">Categories</h1>
		<a class="btn btn-sm btn-primary" href="categories.php#catform"><i class="bi bi-plus-lg"></i> Add category</a>
	</div>

	{if $opt.show_helptext}
		<details class="gr-tips mb-4">
			<summary><i class="bi bi-lightbulb me-1"></i> Tips</summary>
			<p class="small mb-1">
				Here you can specify categories <strong>of your own</strong>, like &quot;Motorcycle stuff&quot; or &quot;Collectibles&quot;. This will help you categorize your gifts.
				Warning: deleting a category will uncategorize all items that used that category.
			</p>
		</details>
	{/if}

	<div class="row g-4">
		<div class="col-lg-7">
			<section class="card gr-card stack-host">
				<div class="card-body p-0 p-md-2">
					<table class="table gr-table table-hover table-stack">
						<thead>
							<tr>
								<th>Category</th>
								<th># Items</th>
								<th><span class="visually-hidden">Actions</span></th>
							</tr>
						</thead>
						<tbody>
							{foreach from=$categories item=row}
								<tr>
									<td class="cell-title">{$row.category}</td>
									<td data-label="Items">{$row.itemsin}</td>
									<td class="cell-actions">
										<a class="btn btn-icon btn-sm btn-outline-secondary" href="categories.php?csrf={$csrf}&action=edit&categoryid={$row.categoryid}#catform" title="Edit Category"><i class="bi bi-pencil"></i><span class="act-label">Edit</span></a>
										<a class="btn btn-icon btn-sm btn-outline-danger" href="categories.php?csrf={$csrf}&action=delete&categoryid={$row.categoryid}" title="Delete Category" data-confirm="Delete the category &quot;{$row.category}&quot;? Items in it will become uncategorized."><i class="bi bi-trash"></i><span class="act-label">Delete</span></a>
									</td>
								</tr>
							{foreachelse}
								<tr class="row-empty"><td colspan="3" class="cell-empty gr-empty"><i class="bi bi-tags"></i>No categories yet.</td></tr>
							{/foreach}
						</tbody>
					</table>
				</div>
			</section>
		</div>

		<div class="col-lg-5">
			<form name="categoryform" id="catform" method="get" action="categories.php" class="card gr-card">
				<input type="hidden" name="csrf" value="{$csrf}">
				{if $action == "edit" || (isset($haserror) && $action == "update")}
					<input type="hidden" name="categoryid" value="{$categoryid}">
					<input type="hidden" name="action" value="update">
				{elseif $action == "" || (isset($haserror) && $action == "insert")}
					<input type="hidden" name="action" value="insert">
				{/if}
				<div class="card-header">
					<h2 class="card-title"><i class="bi bi-tag"></i>{if $action == "edit"}Edit Category '{$category}'{else}Add Category{/if}</h2>
				</div>
				<div class="card-body">
					<label class="form-label" for="category">Category name</label>
					<input id="category" name="category" type="text" class="form-control {if isset($category_error)}is-invalid{/if}" value="{$category}" maxlength="255">
					{if isset($category_error)}<div class="invalid-feedback">{$category_error}</div>{/if}
				</div>
				<div class="card-footer bg-transparent d-flex gap-2">
					<button type="submit" class="btn btn-primary">{if $action == "" || $action == "insert"}Add{else}Update{/if}</button>
					<a class="btn btn-outline-secondary" href="categories.php">Cancel</a>
				</div>
			</form>
		</div>
	</div>
{/block}

{block name=scripts}
	<script>
		$(function() {
			$("#catform").validate({
				rules: {
					category: { required: true, maxlength: 50 }
				},
				messages: {
					category: {
						required: "Category name is required.",
						maxlength: "Category name must be 50 characters or less."
					}
				}
			});
		});
	</script>
{/block}
