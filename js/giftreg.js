// based on http://alittlecode.com/files/jQuery-Validate-Demo/

function validate_highlight(label) {
	$(label).closest('.control-group').removeClass('success').addClass('error');
}

function validate_success(label) {
	$(label).addClass('valid').closest('.control-group').removeClass('error').addClass('success');
}

// Show item images in a Bootstrap modal (replaces the unmaintained
// jquery.lightbox 0.5 plugin, which needs $.browser and fails on jQuery 3).
function enable_image_viewer() {
	$(document).on('click', 'a[rel=lightbox]', function(event) {
		event.preventDefault();
		var $modal = $('#image-viewer');
		if (!$modal.length) {
			$modal = $('<div id="image-viewer" class="modal hide fade" tabindex="-1" role="dialog">' +
				'<div class="modal-header">' +
					'<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>' +
					'<h3></h3>' +
				'</div>' +
				'<div class="modal-body" style="text-align: center; max-height: none;">' +
					'<img alt="" style="max-width: 100%;">' +
				'</div>' +
			'</div>').appendTo('body');
		}
		$modal.find('h3').text($(this).attr('title') || '');	// text(), never html()
		$modal.find('img').attr('src', $(this).attr('href'));
		$modal.modal('show');
	});
}
