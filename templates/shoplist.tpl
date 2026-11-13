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

{block name=title}My Shopping List{/block}

{block name=content}
	<div class="d-flex flex-wrap align-items-center gap-2 mb-3">
		<h1 class="page-title me-auto">My Shopping List</h1>
		{include file='sortmenu.tpl' url='shoplist.php?sort=' options=['recipient' => 'Recipient', 'description' => 'Description', 'ranking' => 'Ranking', 'source' => 'Source', 'price' => 'Price']}
		<button type="button" class="btn btn-sm btn-primary d-print-none" data-print><i class="bi bi-printer"></i> Print</button>
	</div>

	{if $opt.show_helptext}
		<details class="gr-tips mb-4">
			<summary><i class="bi bi-lightbulb me-1"></i> Tips</summary>
			<p class="small mb-1">This is a list of all items you have <strong>reserved</strong>. Once you've bought or decided not to buy an item, remember to return to the recipient's gift lists and mark it accordingly.</p>
		</details>
	{/if}

	<section class="card gr-card stack-host">
		<div class="card-body p-0 p-md-2">
			<table class="table gr-table table-stack">
				<thead>
					<tr>
						<th><a href="shoplist.php?sort=recipient">Recipient</a></th>
						<th><a href="shoplist.php?sort=description">Description</a></th>
						<th><a href="shoplist.php?sort=ranking">Ranking</a></th>
						<th><a href="shoplist.php?sort=source">Source</a></th>
						<th class="text-end"><a href="shoplist.php?sort=price">Price</a></th>
					</tr>
				</thead>
				<tbody>
					{foreach from=$shoplist item=row}
						<tr>
							<td data-label="For">{$row.fullname}</td>
							<td class="cell-title">{$row.description}</td>
							<td data-label="Ranking" class="rank text-nowrap"><span>{$row.rendered nofilter}</span></td>
							<td data-label="Source">{$row.source}</td>
							<td data-label="Price" class="text-end">{$row.price nofilter}</td>
						</tr>
					{foreachelse}
						<tr class="row-empty"><td colspan="5" class="cell-empty gr-empty"><i class="bi bi-cart3"></i>You haven't reserved anything yet.</td></tr>
					{/foreach}
				</tbody>
			</table>
		</div>
		<div class="card-footer bg-transparent fw-semibold">
			{$itemcount} item(s), {$totalprice nofilter} total.
		</div>
	</section>
{/block}
