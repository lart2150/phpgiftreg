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

{block name=title}{if $action == 'edit' || (isset($haserror) && $action == 'update')}Edit Item{else}Add Item{/if}{/block}

{block name=content}
<div class="row justify-content-center">
	<div class="col-lg-8 col-xl-7">
		<h1 class="page-title mb-3">{if $action == 'edit' || (isset($haserror) && $action == 'update')}Edit Item{else}Add Item{/if}</h1>

		{if $opt.show_helptext}
			<details class="gr-tips mb-4">
				<summary><i class="bi bi-lightbulb me-1"></i> Helpful hints</summary>
				<ul class="small">
					<li>Include a URL copied &amp; pasted from the address bar of your browser so that potential buyers can see exactly what you want.</li>
					<li>If the item description and URL can't describe exactly what you want, use the <strong>Comment</strong> area to mention anything you feel is necessary. It doesn't mean the shopper has to buy the item from that website.</li>
					<li>If you don't know the price of the item, simply enter <strong>0</strong>.</li>
					<li>Try not to set all your items at the same ranking level. When someone is shopping for you, they'll rely on the ranking to know what you want the most. If you don't think there are enough levels, or the descriptions aren't adequate, ask an administrator to add or change them.</li>
					{if $opt.allow_multiples}
						<li>The quantity field indicates the number of that item that you want. Once that many are bought or reserved, no more will be available. If you have no limit on how many you want, enter 999 (for example).</li>
					{/if}
				</ul>
			</details>
		{/if}

		<form name="itemform" id="itemform" method="POST" action="item.php" enctype="multipart/form-data" class="card gr-card">
			<div class="card-body p-4">
				<input type="hidden" name="csrf" value="{$csrf}">
				{if $action == 'edit' || (isset($haserror) && $action == 'update')}
					<input type="hidden" name="itemid" value="{$itemid}">
					<input type="hidden" name="action" value="update">
				{elseif $action == "add" || (isset($haserror) && $action == 'insert')}
					<input type="hidden" name="action" value="insert">
				{/if}

				<div class="row g-3">
					<div class="col-12">
						<label class="form-label" for="description">Description</label>
						<input id="description" name="description" type="text" value="{$description}" class="form-control {if isset($description_error)}is-invalid{/if}" placeholder="What would you like?" maxlength="255">
						{if isset($description_error)}<div class="invalid-feedback">{$description_error}</div>{/if}
					</div>

					<div class="col-md-6">
						<label class="form-label" for="category">Category</label>
						<select id="category" name="category" class="form-select {if isset($category_error)}is-invalid{/if}">
							<option value="" {if $category == NULL}selected{/if}>Uncategorized</option>
							{foreach from=$categories item=row}
								<option value="{$row.categoryid}" {if $row.categoryid == $category}selected{/if}>{$row.category}</option>
							{/foreach}
						</select>
						{if isset($category_error)}<div class="invalid-feedback">{$category_error}</div>{/if}
					</div>

					<div class="col-md-6">
						<label class="form-label" for="ranking">Ranking</label>
						<select id="ranking" name="ranking" class="form-select {if isset($ranking_error)}is-invalid{/if}">
							<option value="" {if $ranking == ''}selected{/if}>(select a ranking)</option>
							{foreach from=$ranks item=row}
								<option value="{$row.ranking}" {if $row.ranking == $ranking}selected{/if}>{$row.title}</option>
							{/foreach}
						</select>
						{if isset($ranking_error)}<div class="invalid-feedback">{$ranking_error}</div>{/if}
					</div>

					<div class="{if $opt.allow_multiples}col-sm-6 col-md-4{else}col-md-6{/if}">
						<label class="form-label" for="price">Price</label>
						<div class="input-group {if isset($price_error)}has-validation{/if}">
							<span class="input-group-text">{$opt.currency_symbol nofilter}</span>
							<input id="price" name="price" type="text" inputmode="decimal" value="{$price}" class="form-control {if isset($price_error)}is-invalid{/if}" placeholder="0.00">
							{if isset($price_error)}<div class="invalid-feedback">{$price_error nofilter}</div>{/if}
						</div>
					</div>

					{if $opt.allow_multiples}
						<div class="col-sm-6 col-md-2">
							<label class="form-label" for="quantity">Quantity</label>
							<input id="quantity" name="quantity" type="text" inputmode="numeric" value="{$quantity}" class="form-control {if isset($quantity_error)}is-invalid{/if}" maxlength="3">
							{if isset($quantity_error)}<div class="invalid-feedback">{$quantity_error}</div>{/if}
						</div>
					{else}
						<input type="hidden" name="quantity" value="1">
					{/if}

					<div class="col-md-6">
						<label class="form-label" for="source">Store/Retailer</label>
						<input id="source" name="source" type="text" value="{$source}" class="form-control {if isset($source_error)}is-invalid{/if}" maxlength="255" placeholder="Where can it be found?">
						{if isset($source_error)}<div class="invalid-feedback">{$source_error}</div>{/if}
					</div>

					<div class="col-12">
						<label class="form-label" for="url">URL <span class="gr-subtle">(optional)</span></label>
						<input id="url" name="url" type="url" inputmode="url" value="{$url}" class="form-control {if isset($url_error)}is-invalid{/if}" maxlength="255" placeholder="https://">
						{if isset($url_error)}<div class="invalid-feedback">{$url_error nofilter}</div>{/if}
					</div>

					{if $opt.allow_images}
						<div class="col-12">
							<span class="form-label d-block">Image <span class="gr-subtle">(optional)</span></span>
							{if $image_filename == ''}
								<div class="form-check">
									<input class="form-check-input" type="radio" name="image" value="none" id="ifnone" checked>
									<label class="form-check-label" for="ifnone">No image</label>
								</div>
								<div class="form-check mb-2">
									<input class="form-check-input" type="radio" name="image" value="upload" id="ifnew">
									<label class="form-check-label" for="ifnew">Upload image</label>
								</div>
							{else}
								<div class="form-check">
									<input class="form-check-input" type="radio" name="image" value="keep" id="ifkeep" checked>
									<label class="form-check-label" for="ifkeep">Keep existing image</label>
								</div>
								<div class="form-check">
									<input class="form-check-input" type="radio" name="image" value="remove" id="ifremove">
									<label class="form-check-label" for="ifremove">Remove existing image</label>
								</div>
								<div class="form-check mb-2">
									<input class="form-check-input" type="radio" name="image" value="replace" id="ifreplace">
									<label class="form-check-label" for="ifreplace">Replace existing image</label>
								</div>
							{/if}
							<input type="file" id="imagefile" name="imagefile" accept="image/*" class="form-control {if isset($image_error)}is-invalid{/if}">
							{if isset($image_error)}<div class="invalid-feedback">{$image_error}</div>{/if}
						</div>
					{/if}

					<div class="col-12">
						<label class="form-label" for="comment">Comment</label>
						<textarea id="comment" name="comment" class="form-control" rows="3">{$comment}</textarea>
					</div>
				</div>
			</div>
			<div class="card-footer bg-transparent d-flex gap-2 p-3 px-4">
				<button type="submit" class="btn btn-primary"><i class="bi bi-check-lg"></i> Save</button>
				<a class="btn btn-outline-secondary" href="index.php">Cancel</a>
			</div>
		</form>
	</div>
</div>
{/block}

{block name=scripts}
	<script>
		$(function() {
			// picking a file selects the "upload"/"replace" option for you
			$("#imagefile").on("change", function() {
				$("#ifnew, #ifreplace").prop("checked", true);
			});

			$("#itemform").validate({
				rules: {
					description: { required: true, maxlength: 255 },
					price: { required: true, "number": true, min: 0 },
					source: { required: true, maxlength: 255 },
					ranking: { required: true },
					quantity: { required: true, digits: true, min: 1 },
					url: { url: true }
				},
				messages: {
					description: {
						required: "The item's description is required.",
						maxlength: "The item's description must be 255 characters or less."
					},
					price: {
						required: "The item's price is required.",
						min: "Price can't be a negative number.",
						"number": "Price must be a valid number."
					},
					source: {
						required: "A source to buy the item is required.",
						maxlength: "The source must be 255 characters or less."
					},
					ranking: { required: "A ranking is required." },
					quantity: {
						required: "A quantity is required.",
						digits: "Quantity must be a valid number.",
						min: "Quantity can't be negative"
					},
					url: { url: "If specified, URL must be valid." }
				}
			});
		});
	</script>
{/block}
