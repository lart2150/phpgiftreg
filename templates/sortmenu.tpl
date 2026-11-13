{*
	Sort dropdown for phones, where stacked tables hide their sortable headers.
	Params: url (prefix the sort key is appended to), options (key => label).
*}
<div class="dropdown d-md-none d-print-none">
	<button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
		<i class="bi bi-sort-down"></i> Sort
	</button>
	<ul class="dropdown-menu dropdown-menu-end">
		{foreach $options as $key => $label}
			<li><a class="dropdown-item" href="{$url}{$key}">{$label}</a></li>
		{/foreach}
	</ul>
</div>
