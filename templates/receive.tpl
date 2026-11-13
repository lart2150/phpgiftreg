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

{block name=title}Receive an Item{/block}

{block name=content}
<div class="row justify-content-center">
	<div class="col-md-8 col-lg-6">
		<h1 class="page-title mb-3">Mark item received</h1>
		<form name="receiverform" id="receiverform" method="get" action="receive.php" class="card gr-card">
			<input type="hidden" name="csrf" value="{$csrf}">
			<input type="hidden" name="action" value="receive">
			<input type="hidden" name="itemid" value="{$itemid}">
			<div class="card-body">
				<div class="mb-3">
					<label class="form-label" for="buyer">Buyer</label>
					<select id="buyer" name="buyer" class="form-select">
						<option value="">(select buyer)</option>
						{foreach from=$buyers item=row}
							<option value="{$row.userid}">{$row.fullname}</option>
						{/foreach}
					</select>
				</div>
				<div>
					<label class="form-label" for="quantity">Quantity received <span class="gr-subtle">(maximum of {$quantity})</span></label>
					<input type="number" id="quantity" name="quantity" value="1" min="1" max="{$quantity}" class="form-control" style="max-width: 8rem;">
					<div class="form-text">Once you have received all of an item, it will be deleted.</div>
				</div>
			</div>
			<div class="card-footer bg-transparent d-flex gap-2">
				<button type="submit" class="btn btn-primary"><i class="bi bi-box2-heart"></i> Receive Item</button>
				<a class="btn btn-outline-secondary" href="index.php">Cancel</a>
			</div>
		</form>
	</div>
</div>
{/block}

{block name=scripts}
	<script>
		$(function() {
			$("#receiverform").validate({
				rules: {
					buyer: { required: true },
					quantity: { required: true, digits: true, min: 1, max: {$quantity} }
				},
				messages: {
					buyer: { required: "Please select a buyer." },
					quantity: {
						required: "Please enter the quantity you received.",
						digits: "Quantity must be a valid number.",
						min: "Quantity must be 1 or greater.",
						max: "Quantity must be {$quantity} or less."
					}
				}
			});
		});
	</script>
{/block}
