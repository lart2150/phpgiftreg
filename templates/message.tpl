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

{block name=title}Compose a Message{/block}

{block name=content}
<div class="row justify-content-center">
	<div class="col-lg-8 col-xl-7">
		<h1 class="page-title mb-3">Send a message</h1>
		<form name="message" method="get" action="message.php" class="card gr-card">
			<input type="hidden" name="csrf" value="{$csrf}">
			<input type="hidden" name="action" value="send">
			<div class="card-body">
				<fieldset class="mb-3">
					<legend class="form-label fs-6 mb-2">Recipients</legend>
					{* Checkboxes instead of a ctrl-click multi-select: usable on touch screens. *}
					<div class="border rounded p-2" style="max-height: 16rem; overflow-y: auto;">
						{foreach from=$recipients item=row}
							<div class="form-check">
								<input class="form-check-input" type="checkbox" name="recipients[]" value="{$row.userid}" id="recipient-{$row.userid}">
								<label class="form-check-label" for="recipient-{$row.userid}">{$row.fullname}</label>
							</div>
						{foreachelse}
							<div class="gr-subtle small p-1">There's no one to send a message to yet.</div>
						{/foreach}
					</div>
				</fieldset>
				<div>
					<label class="form-label" for="msg">Message</label>
					<textarea id="msg" name="msg" rows="5" class="form-control"></textarea>
				</div>
			</div>
			<div class="card-footer bg-transparent d-flex gap-2">
				<button type="submit" class="btn btn-primary"><i class="bi bi-send"></i> Send Message</button>
				<a class="btn btn-outline-secondary" href="index.php">Cancel</a>
			</div>
		</form>
	</div>
</div>
{/block}
