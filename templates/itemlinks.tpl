{*
	Comment / URL / image links shown after an item's description.
	Param: row (an item row with comment, url, image_filename, description).
*}
{if $row.comment != ''}
	<a tabindex="0" role="button" class="ms-1 gr-subtle d-print-none" data-bs-toggle="popover" data-bs-trigger="focus" data-bs-placement="top" data-bs-title="Comment" data-bs-content="{$row.comment}" aria-label="Show comment"><i class="bi bi-chat-left-text"></i></a>
{/if}
{if $row.url != ''}
	<a class="ms-1 gr-subtle d-print-none" href="{$row.url}" target="_blank" rel="noopener noreferrer" title="Open link" aria-label="Open link"><i class="bi bi-box-arrow-up-right"></i></a>
{/if}
{if $row.image_filename != '' && $opt.allow_images}
	<a class="ms-1 gr-subtle d-print-none" data-gr-image href="{$opt.image_subdir}/{$row.image_filename}" title="{$row.description}" aria-label="Show image"><i class="bi bi-image"></i></a>
{/if}
