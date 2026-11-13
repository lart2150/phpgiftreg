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

{block name=title}Shopping List for {$ufullname}{/block}

{block name=content}
	<div class="d-flex flex-wrap align-items-center gap-2 mb-3">
		<h1 class="page-title me-auto">Shopping for {$ufullname}</h1>
		<button type="button" class="btn btn-sm btn-outline-secondary d-print-none" data-print><i class="bi bi-printer"></i> Print</button>
	</div>

	{if $opt.show_helptext}
		<details class="gr-tips mb-4">
			<summary><i class="bi bi-lightbulb me-1"></i> Tips</summary>
			<ul class="small">
				<li>If you intend to purchase a gift for this person, click <i class="bi bi-lock"></i> <strong>Reserve</strong>. If you end up actually purchasing it, come back and click <i class="bi bi-credit-card"></i> <strong>Purchase</strong>. If you change your mind and don't want to buy it, come back and click <i class="bi bi-unlock"></i> <strong>Release</strong>.</li>
				<li>If you return something you've purchased, come back and click <i class="bi bi-arrow-counterclockwise"></i> <strong>Return</strong>. It will remain reserved for you.</li>
				<li>Just because an item has a URL listed doesn't mean you have to buy it from there (unless the comment says so).</li>
				<li>You can click the column headers to sort by that attribute.</li>
				<li>If you see something you'd like for yourself, click <i class="bi bi-copy"></i> <strong>I Want This Too</strong> to copy it to your own list.</li>
			</ul>
		</details>
	{/if}

	<section class="card gr-card stack-host">
		<div class="card-header d-flex flex-wrap align-items-center gap-2">
			<div class="small gr-subtle me-auto d-none d-md-block">
				<i class="bi bi-lock"></i> Reserve &nbsp;
				<i class="bi bi-unlock"></i> Release &nbsp;
				<i class="bi bi-credit-card"></i> Purchase &nbsp;
				<i class="bi bi-arrow-counterclockwise"></i> Return &nbsp;
				<i class="bi bi-copy"></i> I Want This Too
			</div>
			<div class="ms-auto">
				{include file='sortmenu.tpl' url="shop.php?shopfor={$shopfor}&sort=" options=['ranking' => 'Rank', 'description' => 'Description', 'category' => 'Category', 'price' => 'Price', 'source' => 'Store/Location', 'status' => 'Status']}
			</div>
		</div>
		<div class="card-body p-0 p-md-2">
			<table class="table gr-table table-hover table-stack">
				<thead>
					<tr>
						<th><a href="shop.php?shopfor={$shopfor}&sort=ranking">Rank</a></th>
						<th><a href="shop.php?shopfor={$shopfor}&sort=description">Description</a></th>
						<th><a href="shop.php?shopfor={$shopfor}&sort=category">Category</a></th>
						<th class="text-end"><a href="shop.php?shopfor={$shopfor}&sort=price">Price</a></th>
						<th><a href="shop.php?shopfor={$shopfor}&sort=source">Store/Location</a></th>
						<th><a href="shop.php?shopfor={$shopfor}&sort=status">Status</a></th>
						<th class="d-print-none"><span class="visually-hidden">Actions</span></th>
					</tr>
				</thead>
				<tbody>
				{foreach from=$shoprows item=row}
					<tr>
						<td data-label="Rank" class="rank text-nowrap"><span>{$row.rendered nofilter}</span></td>
						<td class="cell-title">
							{$row.description}
							{include file='itemlinks.tpl' row=$row}
						</td>
						<td data-label="Category">{if $row.category != ''}{$row.category}{else}<span class="gr-subtle">&mdash;</span>{/if}</td>
						<td data-label="Price" class="text-end">{$row.price nofilter}</td>
						<td data-label="Store">{$row.source}</td>

						{* ----- status ----- *}
						<td data-label="Status">
							{if $row.quantity > 1}
								<div>
									{foreach from=$row.allocs item=alloc}
										<div class="fw-semibold">{$alloc}</div>
									{/foreach}
									<div class="gr-subtle">{$row.avail} remaining.</div>
								</div>
							{elseif $row.rfullname == '' && $row.bfullname == ''}
								<span class="badge status-badge badge-evergreen">Available</span>
							{elseif $row.rfullname != ''}
								{if $row.reservedid == $userid}
									<span class="badge status-badge badge-accent"><i class="bi bi-lock-fill"></i> Reserved by you</span>
								{elseif $opt.anonymous_purchasing}
									<span class="badge status-badge text-bg-secondary">Reserved</span>
								{else}
									<span class="badge status-badge text-bg-secondary">Reserved by {$row.rfullname}</span>
								{/if}
							{else}
								{if $row.boughtid == $userid}
									<span class="badge status-badge badge-accent"><i class="bi bi-bag-check-fill"></i> Bought by you</span>
								{elseif $opt.anonymous_purchasing}
									<span class="badge status-badge text-bg-secondary">Bought</span>
								{else}
									<span class="badge status-badge text-bg-secondary">Bought by {$row.bfullname}</span>
								{/if}
							{/if}
						</td>

						{* ----- actions ----- *}
						<td class="cell-actions d-print-none">
							{if $row.quantity > 1}
								{if $row.avail > 0 || $row.ireserved > 0 || $row.ibought > 0}
									{if $row.ireserved > 0}
										{assign var="reservetext" value="Reserve Another"}
									{else}
										{assign var="reservetext" value="Reserve Item"}
									{/if}
									{if $row.ibought > 0}
										{assign var="purchasetext" value="Purchase Another"}
									{elseif $row.ireserved > 0}
										{assign var="purchasetext" value="Convert Reserve to Purchase"}
									{else}
										{assign var="purchasetext" value="Purchase Item"}
									{/if}
									{if $row.avail > 0}
										<a class="btn btn-icon btn-sm btn-outline-primary" href="shop.php?csrf={$csrf}&action=reserve&itemid={$row.itemid}&shopfor={$shopfor}" title="{$reservetext}"><i class="bi bi-lock"></i><span class="act-label">{$reservetext}</span></a>
									{/if}
									{if $row.avail > 0 || $row.ireserved > 0}
										<a class="btn btn-icon btn-sm btn-outline-success" href="shop.php?csrf={$csrf}&action=purchase&itemid={$row.itemid}&shopfor={$shopfor}" title="{$purchasetext}"><i class="bi bi-credit-card"></i><span class="act-label">{$purchasetext}</span></a>
									{/if}
								{/if}
								{if $row.ireserved > 0}
									<a class="btn btn-icon btn-sm btn-outline-secondary" href="shop.php?csrf={$csrf}&action=release&itemid={$row.itemid}&shopfor={$shopfor}" title="Release Item"><i class="bi bi-unlock"></i><span class="act-label">Release</span></a>
								{/if}
								{if $row.ibought > 0}
									<a class="btn btn-icon btn-sm btn-outline-secondary" href="shop.php?csrf={$csrf}&action=return&itemid={$row.itemid}&shopfor={$shopfor}" title="Return Item"><i class="bi bi-arrow-counterclockwise"></i><span class="act-label">Return</span></a>
								{/if}
							{elseif $row.rfullname == '' && $row.bfullname == ''}
								<a class="btn btn-icon btn-sm btn-outline-primary" href="shop.php?csrf={$csrf}&action=reserve&itemid={$row.itemid}&shopfor={$shopfor}" title="Reserve Item"><i class="bi bi-lock"></i><span class="act-label">Reserve</span></a>
								<a class="btn btn-icon btn-sm btn-outline-success" href="shop.php?csrf={$csrf}&action=purchase&itemid={$row.itemid}&shopfor={$shopfor}" title="Purchase Item"><i class="bi bi-credit-card"></i><span class="act-label">Purchase</span></a>
							{elseif $row.rfullname != ''}
								{if $row.reservedid == $userid}
									<a class="btn btn-icon btn-sm btn-outline-secondary" href="shop.php?csrf={$csrf}&action=release&itemid={$row.itemid}&shopfor={$shopfor}" title="Release Item"><i class="bi bi-unlock"></i><span class="act-label">Release</span></a>
									<a class="btn btn-icon btn-sm btn-outline-success" href="shop.php?csrf={$csrf}&action=purchase&itemid={$row.itemid}&shopfor={$shopfor}" title="Purchase Item"><i class="bi bi-credit-card"></i><span class="act-label">Purchase</span></a>
								{/if}
							{elseif $row.boughtid == $userid}
								<a class="btn btn-icon btn-sm btn-outline-secondary" href="shop.php?csrf={$csrf}&action=return&itemid={$row.itemid}&shopfor={$shopfor}" title="Return Item"><i class="bi bi-arrow-counterclockwise"></i><span class="act-label">Return</span></a>
							{/if}
							<a class="btn btn-icon btn-sm btn-outline-secondary" href="shop.php?csrf={$csrf}&action=copy&itemid={$row.itemid}&shopfor={$shopfor}" title="I Want This Too"><i class="bi bi-copy"></i><span class="act-label">I Want This Too</span></a>
						</td>
					</tr>
				{foreachelse}
					<tr class="row-empty">
						<td colspan="7" class="cell-empty gr-empty"><i class="bi bi-gift"></i>{$ufullname} hasn't added any items yet.</td>
					</tr>
				{/foreach}
				</tbody>
			</table>
		</div>
	</section>
{/block}
