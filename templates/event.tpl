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

{block name=title}Manage Events{/block}

{block name=content}
	{assign var="editing" value=($action == "edit" || (isset($haserror) && $action == "update"))}

	<div class="d-flex flex-wrap align-items-center gap-2 mb-3">
		<h1 class="page-title me-auto">Events</h1>
		<a class="btn btn-sm btn-primary" href="event.php#eventform"><i class="bi bi-plus-lg"></i> Add event</a>
	</div>

	{if $opt.show_helptext}
		<details class="gr-tips mb-4">
			<summary><i class="bi bi-lightbulb me-1"></i> Tips</summary>
			<p class="small mb-1">
				Here you can specify events <strong>of your own</strong>, like your birthday or your anniversary. When the event occurs within {$opt.event_threshold} days, an event reminder will appear in the display of everyone who shops for you.
				{if $isadmin}
					<strong>System events</strong> are events which belong to no one -- like Christmas -- and will appear on everyone's display.
				{/if}
				Marking an item as <strong>Recurring yearly</strong> will cause them to show up year after year.
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
								<th>Description</th>
								<th>Event date</th>
								<th>Recurring?</th>
								{if $isadmin}<th>System event?</th>{/if}
								<th><span class="visually-hidden">Actions</span></th>
							</tr>
						</thead>
						<tbody>
							{foreach from=$events item=row}
								<tr>
									<td class="cell-title">{$row.description}</td>
									<td data-label="Date">{$row.eventdate}</td>
									<td data-label="Recurring">{if $row.recurring}<i class="bi bi-arrow-repeat text-evergreen"></i> Yes{else}No{/if}</td>
									{if $isadmin}
										<td data-label="System event">{if $row.userid == ''}Yes{else}No{/if}</td>
									{/if}
									<td class="cell-actions">
										<a class="btn btn-icon btn-sm btn-outline-secondary" href="event.php?csrf={$csrf}&action=edit&eventid={$row.eventid}#eventform" title="Edit Event"><i class="bi bi-pencil"></i><span class="act-label">Edit</span></a>
										<a class="btn btn-icon btn-sm btn-outline-danger" href="event.php?csrf={$csrf}&action=delete&eventid={$row.eventid}" title="Delete Event" data-confirm="Are you sure you want to delete the event &quot;{$row.description}&quot;?"><i class="bi bi-trash"></i><span class="act-label">Delete</span></a>
									</td>
								</tr>
							{foreachelse}
								<tr class="row-empty"><td colspan="{if $isadmin}5{else}4{/if}" class="cell-empty gr-empty"><i class="bi bi-calendar"></i>No events yet.</td></tr>
							{/foreach}
						</tbody>
					</table>
				</div>
			</section>
		</div>

		<div class="col-lg-5">
			<form name="eventform" id="eventform" method="get" action="event.php" class="card gr-card">
				<div class="card-header">
					<h2 class="card-title"><i class="bi bi-calendar-plus"></i>{if $editing}Edit Event{else}Add Event{/if}</h2>
				</div>
				<div class="card-body">
					<input type="hidden" name="csrf" value="{$csrf}">
					{if $editing}
						<input type="hidden" name="eventid" value="{$eventid}">
						<input type="hidden" name="action" value="update">
					{elseif $action == "" || (isset($haserror) && $action == "insert")}
						<input type="hidden" name="action" value="insert">
					{/if}
					<div class="mb-3">
						<label class="form-label" for="description">Description</label>
						<input id="description" name="description" type="text" value="{$description}" class="form-control {if isset($description_error)}is-invalid{/if}" maxlength="255" placeholder="e.g. Birthday">
						{if isset($description_error)}<div class="invalid-feedback">{$description_error}</div>{/if}
					</div>
					<div class="mb-3">
						<label class="form-label" for="eventdate">Event date</label>
						<input id="eventdate" name="eventdate" type="date" value="{$eventdate}" class="form-control {if isset($eventdate_error)}is-invalid{/if}">
						{if isset($eventdate_error)}<div class="invalid-feedback">{$eventdate_error}</div>{/if}
					</div>
					<div class="form-check mb-2">
						<input class="form-check-input" type="checkbox" name="recurring" id="recurring" {if $recurring}checked{/if}>
						<label class="form-check-label" for="recurring">Recurring yearly</label>
					</div>
					{if $isadmin}
						<div class="form-check mb-2">
							<input class="form-check-input" type="checkbox" name="systemevent" id="systemevent" {if $systemevent}checked{/if}>
							<label class="form-check-label" for="systemevent">System event <span class="gr-subtle">(shows for everyone)</span></label>
						</div>
					{/if}
				</div>
				<div class="card-footer bg-transparent d-flex gap-2">
					<button type="submit" class="btn btn-primary">{if $action == "" || $action == "insert"}Add{else}Update{/if}</button>
					<a class="btn btn-outline-secondary" href="event.php">Cancel</a>
				</div>
			</form>
		</div>
	</div>
{/block}

{block name=scripts}
	<script>
		$(function() {
			$('#eventform').validate({
				rules: {
					description: { required: true, maxlength: 255 },
					eventdate: { required: true, dateISO: true }
				},
				messages: {
					description: {
						required: "A description of the event is required.",
						maxlength: "The description must be 255 characters or less."
					},
					eventdate: {
						required: "The event date is required.",
						dateISO: "The event date must be a valid date."
					}
				}
			});
		});
	</script>
{/block}
