// Follow the OS light/dark preference. Loaded synchronously in <head> so the
// page never flashes the wrong theme.
(function () {
	var query = window.matchMedia ? window.matchMedia('(prefers-color-scheme: dark)') : null;
	function apply() {
		document.documentElement.setAttribute('data-bs-theme', query && query.matches ? 'dark' : 'light');
	}
	apply();
	if (query && query.addEventListener) {
		query.addEventListener('change', apply);
	}
})();
