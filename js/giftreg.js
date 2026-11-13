// Shared page behaviour for the Gift Registry (Bootstrap 5).

// jquery.validate -> Bootstrap 5 validation styling. Pages only supply rules/messages.
if (window.jQuery && jQuery.validator) {
	jQuery.validator.setDefaults({
		errorElement: 'div',
		errorClass: 'invalid-feedback',
		highlight: function (element) {
			jQuery(element).addClass('is-invalid');
		},
		unhighlight: function (element) {
			jQuery(element).removeClass('is-invalid');
		},
		errorPlacement: function (error, element) {
			var $group = element.closest('.input-group, .form-check');
			var $anchor = $group.length ? $group : element;
			// replace any server-side message for this field (client ones have id "<field>-error")
			$anchor.parent().find('.invalid-feedback').not('[id$="-error"]').remove();
			error.insertAfter($anchor);
		}
	});
}

document.addEventListener('DOMContentLoaded', function () {
	// Comment popovers. trigger=focus closes them on the next tap, which works on touch screens.
	document.querySelectorAll('[data-bs-toggle="popover"]').forEach(function (el) {
		new bootstrap.Popover(el);
	});
});

// Confirm before following links/submitting buttons that carry data-confirm.
document.addEventListener('click', function (event) {
	var el = event.target.closest('[data-confirm]');
	if (el && !window.confirm(el.getAttribute('data-confirm'))) {
		event.preventDefault();
	}
});

// "Print" buttons.
document.addEventListener('click', function (event) {
	if (event.target.closest('[data-print]')) {
		event.preventDefault();
		window.print();
	}
});

// Show item images in a Bootstrap modal.
document.addEventListener('click', function (event) {
	var link = event.target.closest('a[data-gr-image]');
	if (!link) {
		return;
	}
	event.preventDefault();

	var modalEl = document.getElementById('image-viewer');
	if (!modalEl) {
		modalEl = document.createElement('div');
		modalEl.id = 'image-viewer';
		modalEl.className = 'modal fade';
		modalEl.tabIndex = -1;
		modalEl.setAttribute('aria-hidden', 'true');
		modalEl.innerHTML =
			'<div class="modal-dialog modal-dialog-centered modal-lg">' +
				'<div class="modal-content">' +
					'<div class="modal-header">' +
						'<h2 class="modal-title fs-5"></h2>' +
						'<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>' +
					'</div>' +
					'<div class="modal-body text-center">' +
						'<img alt="" class="img-fluid rounded">' +
					'</div>' +
				'</div>' +
			'</div>';
		document.body.appendChild(modalEl);
	}
	var title = link.getAttribute('title') || '';
	modalEl.querySelector('.modal-title').textContent = title;	// textContent, never innerHTML
	var img = modalEl.querySelector('img');
	img.src = link.getAttribute('href');
	img.alt = title;
	bootstrap.Modal.getOrCreateInstance(modalEl).show();
});
