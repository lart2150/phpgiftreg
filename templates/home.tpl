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

{block name=title}Home Page for {$fullname}{/block}

{block name=content}
	<div class="d-flex flex-wrap align-items-center justify-content-between gap-2 mb-3">
		<h1 class="page-title">Hi, {$fullname}</h1>
	</div>

	{if $opt.show_helptext}
		<details class="gr-tips mb-4">
			<summary><i class="bi bi-lightbulb me-1"></i> Tips</summary>
			<ul class="small">
				<li>You can click the column headers to sort by that attribute.</li>
				<li>List each item separately on your list - do not combine items. (i.e. list each book of a 4-part series separately.)</li>
				<li>Once you've bought or decided not to buy an item, remember to return to the recipient's gift lists and mark it accordingly.</li>
				<li>If someone purchases an item on your list, click <i class="bi bi-box2-heart"></i> <strong>Received</strong> to mark it as received.</li>
			</ul>
		</details>
	{/if}

	<section id="myitems" class="card gr-card stack-host mb-4">
		<div class="card-header d-flex flex-wrap align-items-center gap-2">
			<h2 class="card-title me-auto"><i class="bi bi-gift"></i>My Items</h2>
			{include file='sortmenu.tpl' url='index.php?mysort=' options=['description' => 'Description', 'ranking' => 'Ranking', 'category' => 'Category', 'price' => 'Price']}
			<a class="btn btn-sm btn-primary" href="item.php?csrf={$csrf}&action=add"><i class="bi bi-plus-lg"></i> Add item</a>
		</div>
		<div class="card-body p-0 p-md-2">
			<table class="table gr-table table-hover table-stack">
				<thead>
					<tr>
						<th><a href="index.php?mysort=description">Description</a></th>
						<th><a href="index.php?mysort=ranking">Ranking</a></th>
						<th><a href="index.php?mysort=category">Category</a></th>
						<th class="text-end"><a href="index.php?mysort=price">Price</a></th>
						<th><span class="visually-hidden">Actions</span></th>
					</tr>
				</thead>
				<tbody>
					{foreach from=$myitems item=row}
						<tr>
							<td class="cell-title">
								{$row.description}
								{include file='itemlinks.tpl' row=$row}
							</td>
							<td data-label="Ranking" class="rank text-nowrap"><span>{$row.rendered nofilter}</span></td>
							<td data-label="Category">{if $row.category != ''}{$row.category}{else}<span class="gr-subtle">&mdash;</span>{/if}</td>
							<td data-label="Price" class="text-end">{$row.price nofilter}</td>
							<td class="cell-actions">
								<a class="btn btn-icon btn-sm btn-outline-success" href="receive.php?csrf={$csrf}&itemid={$row.itemid}" title="Mark Item Received"><i class="bi bi-box2-heart"></i><span class="act-label">Received</span></a>
								<a class="btn btn-icon btn-sm btn-outline-secondary" href="item.php?csrf={$csrf}&action=edit&itemid={$row.itemid}" title="Edit Item"><i class="bi bi-pencil"></i><span class="act-label">Edit</span></a>
								<a class="btn btn-icon btn-sm btn-outline-danger" href="item.php?csrf={$csrf}&action=delete&itemid={$row.itemid}" title="Delete Item" {if $opt.confirm_item_deletes}data-confirm="Are you sure you want to delete &quot;{$row.description}&quot;?"{/if}><i class="bi bi-trash"></i><span class="act-label">Delete</span></a>
							</td>
						</tr>
					{foreachelse}
						<tr class="row-empty">
							<td colspan="5" class="cell-empty gr-empty">
								<i class="bi bi-gift"></i>
								Your list is empty. <a href="item.php?csrf={$csrf}&action=add">Add your first item</a>.
							</td>
						</tr>
					{/foreach}
				</tbody>
			</table>
		</div>
		{if $myitems_count > $opt.items_per_page}
			<div class="card-footer bg-transparent border-0 pt-0">
				<nav aria-label="My items pages">
					<ul class="pagination pagination-sm flex-wrap mb-0">
						{if $offset >= $opt.items_per_page}
							<li class="page-item"><a class="page-link" href="index.php?offset={$offset - $opt.items_per_page}" aria-label="Previous">&lsaquo;</a></li>
						{/if}
						{for $i=0 to $myitems_count step $opt.items_per_page}
							<li class="page-item {if $offset >= $i && $offset < $i + $opt.items_per_page}active{/if}"><a class="page-link" href="index.php?offset={$i}">{$i + $opt.items_per_page}</a></li>
						{/for}
						{if $offset + $opt.items_per_page < $myitems_count}
							<li class="page-item"><a class="page-link" href="index.php?offset={$offset + $opt.items_per_page}" aria-label="Next">&rsaquo;</a></li>
						{/if}
					</ul>
				</nav>
			</div>
		{/if}
	</section>

	<div class="row g-4">
		<div class="col-lg-6">
			<section class="card gr-card h-100">
				<div class="card-header">
					<h2 class="card-title"><i class="bi bi-bag-heart"></i>People I'm shopping for</h2>
				</div>
				<div class="list-group list-group-flush gr-list">
					{foreach from=$shoppees item=row}
						<div class="list-group-item d-flex align-items-center gap-2">
							<div class="flex-grow-1 text-break">
								<a class="fw-semibold" href="shop.php?shopfor={$row.userid}">{$row.fullname}</a>
								{if $row.comment != ''}
									<a tabindex="0" role="button" class="ms-1 gr-subtle" data-bs-toggle="popover" data-bs-trigger="focus" data-bs-placement="top" data-bs-title="Comment" data-bs-content="{$row.comment}" aria-label="Comment"><i class="bi bi-chat-left-text"></i></a>
								{/if}
								<div class="small gr-subtle">
									{$row.itemcount} item{if $row.itemcount != 1}s{/if}{if $row.list_stamp != ''} &middot; updated {$row.list_stamp}{/if}
								</div>
							</div>
							<div class="d-flex gap-1 flex-shrink-0">
								{if $row.itemcount > 0}
									<a class="btn btn-sm btn-primary" href="shop.php?shopfor={$row.userid}" title="Shop for {$row.fullname}"><i class="bi bi-bag"></i><span class="d-none d-sm-inline ms-1">Shop</span></a>
								{/if}
								{if !$row.is_unsubscribed}
									<a class="btn btn-sm btn-outline-secondary" href="index.php?csrf={$csrf}&action=unsubscribe&shoppee={$row.userid}" title="Unsubscribe from {$row.fullname}'s updates" aria-label="Unsubscribe from {$row.fullname}'s updates"><i class="bi bi-bell-fill"></i></a>
								{else}
									<a class="btn btn-sm btn-outline-secondary" href="index.php?csrf={$csrf}&action=subscribe&shoppee={$row.userid}" title="Subscribe to {$row.fullname}'s updates" aria-label="Subscribe to {$row.fullname}'s updates"><i class="bi bi-bell-slash"></i></a>
								{/if}
								<a class="btn btn-sm btn-outline-danger" href="index.php?csrf={$csrf}&action=cancel&shopfor={$row.userid}" title="Don't shop for {$row.fullname} anymore" aria-label="Don't shop for {$row.fullname} anymore" {if $opt.shop_requires_approval}data-confirm="Are you sure you no longer wish to shop for {$row.fullname}?"{/if}><i class="bi bi-person-dash"></i></a>
							</div>
						</div>
					{foreachelse}
						<div class="list-group-item gr-empty"><i class="bi bi-people"></i>You're not shopping for anyone yet.</div>
					{/foreach}
				</div>
			</section>
		</div>

		<div class="col-lg-6">
			<section class="card gr-card h-100">
				<div class="card-header">
					<h2 class="card-title"><i class="bi bi-person-plus"></i>People I'm not shopping for</h2>
				</div>
				<div class="list-group list-group-flush gr-list">
					{foreach from=$prospects item=row}
						<div class="list-group-item d-flex align-items-center gap-2">
							<div class="flex-grow-1 text-break">{$row.fullname}</div>
							{if $row.pending}
								<span class="badge status-badge text-bg-secondary">Pending</span>
								<a class="btn btn-sm btn-outline-secondary" href="index.php?csrf={$csrf}&action=cancel&shopfor={$row.userid}" title="Cancel request" aria-label="Cancel request"><i class="bi bi-x-lg"></i></a>
							{else}
								<a class="btn btn-sm btn-outline-primary" href="index.php?csrf={$csrf}&action=request&shopfor={$row.userid}">
									<i class="bi bi-plus-lg"></i> {if $opt.shop_requires_approval}Request{else}Add{/if}
								</a>
							{/if}
						</div>
					{foreachelse}
						<div class="list-group-item gr-empty"><i class="bi bi-emoji-smile"></i>You're shopping for everyone.</div>
					{/foreach}
				</div>
			</section>
		</div>

		<div class="col-lg-6">
			<section class="card gr-card h-100">
				<div class="card-header d-flex align-items-center">
					<h2 class="card-title me-auto"><i class="bi bi-envelope"></i>Messages</h2>
					<a class="btn btn-sm btn-outline-primary" href="message.php"><i class="bi bi-send"></i> Send a message</a>
				</div>
				<div class="list-group list-group-flush gr-list">
					{foreach from=$messages item=row}
						<div class="list-group-item d-flex align-items-start gap-2">
							<div class="flex-grow-1 text-break">
								<div class="small gr-subtle"><strong class="text-body">{$row.fullname}</strong> &middot; {$row.created}</div>
								<div style="white-space: pre-line;">{$row.message}</div>
							</div>
							<a class="btn btn-sm btn-outline-secondary flex-shrink-0" href="index.php?csrf={$csrf}&action=ack&messageid={$row.messageid}" title="Acknowledge" aria-label="Acknowledge"><i class="bi bi-check2"></i></a>
						</div>
					{foreachelse}
						<div class="list-group-item gr-empty"><i class="bi bi-inbox"></i>No messages.</div>
					{/foreach}
				</div>
			</section>
		</div>

		<div class="col-lg-6">
			<section class="card gr-card h-100">
				<div class="card-header">
					<h2 class="card-title"><i class="bi bi-calendar-heart"></i>Upcoming events <span class="small fw-normal gr-subtle">(within {$opt.event_threshold} days)</span></h2>
				</div>
				<div class="list-group list-group-flush gr-list">
					{foreach from=$events item=row}
						<div class="list-group-item d-flex align-items-center gap-2">
							<div class="flex-grow-1 text-break">
								<div class="fw-semibold">{$row.eventname}</div>
								<div class="small gr-subtle">
									{if $row.fullname == ''}<i>System event</i>{else}{$row.fullname}{/if} &middot; {$row.date}
								</div>
							</div>
							{if $row.daysleft == 0}
								<span class="badge status-badge text-bg-primary">Today</span>
							{else}
								<span class="badge status-badge badge-accent">{$row.daysleft} day{if $row.daysleft != 1}s{/if}</span>
							{/if}
						</div>
					{foreachelse}
						<div class="list-group-item gr-empty"><i class="bi bi-calendar"></i>Nothing coming up.</div>
					{/foreach}
				</div>
			</section>
		</div>

		{if $opt.shop_requires_approval}
			<div class="col-lg-6">
				<section class="card gr-card h-100">
					<div class="card-header">
						<h2 class="card-title"><i class="bi bi-hand-thumbs-up"></i>People who want to shop for me</h2>
					</div>
					<div class="list-group list-group-flush gr-list">
						{foreach from=$pending item=row}
							<div class="list-group-item d-flex align-items-center gap-2">
								<div class="flex-grow-1 text-break">{$row.fullname}</div>
								<a class="btn btn-sm btn-success" href="index.php?csrf={$csrf}&action=approve&shopper={$row.userid}">Approve</a>
								<a class="btn btn-sm btn-outline-secondary" href="index.php?csrf={$csrf}&action=decline&shopper={$row.userid}">Decline</a>
							</div>
						{foreachelse}
							<div class="list-group-item gr-empty"><i class="bi bi-check2-all"></i>No pending requests.</div>
						{/foreach}
					</div>
				</section>
			</div>
		{/if}

		{if $isadmin && $opt.newuser_requires_approval}
			<div class="col-lg-6">
				<section class="card gr-card h-100">
					<div class="card-header">
						<h2 class="card-title"><i class="bi bi-person-check"></i>People waiting for approval</h2>
					</div>
					<div class="list-group list-group-flush gr-list">
						{foreach from=$approval item=row}
							<div class="list-group-item d-flex flex-wrap align-items-center gap-2">
								<div class="flex-grow-1 text-break">
									<div class="fw-semibold">{$row.fullname}</div>
									<div class="small gr-subtle"><a href="mailto:{$row.email}">{$row.email}</a> &middot; {$row.familyname}</div>
								</div>
								<div class="d-flex gap-1">
									<a class="btn btn-sm btn-success" href="admin.php?csrf={$csrf}&action=approve&userid={$row.userid}&familyid={$row.initialfamilyid}">Approve</a>
									<a class="btn btn-sm btn-outline-danger" href="admin.php?csrf={$csrf}&action=reject&userid={$row.userid}">Reject</a>
								</div>
							</div>
						{foreachelse}
							<div class="list-group-item gr-empty"><i class="bi bi-check2-all"></i>No one is waiting.</div>
						{/foreach}
					</div>
				</section>
			</div>
		{/if}
	</div>
{/block}
