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
{*
	Base page. Child templates {extends file='layout.tpl'} and fill these blocks:
	  title    - text after "Gift Registry - "
	  content  - the page body
	  scripts  - page-specific <script> (jQuery, jquery.validate and giftreg.js are already loaded)
	  navbar / flash / bodyclass / main - override for auth pages
*}
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta name="color-scheme" content="light dark">
	<title>Gift Registry - {block name=title}{/block}</title>
	<script src="js/theme.js"></script>
	<link href="bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<link href="bootstrap-icons/bootstrap-icons.min.css" rel="stylesheet">
	<link href="css/giftreg.css" rel="stylesheet">
</head>
<body class="{block name=bodyclass}{/block}">
	{block name=navbar}{include file='navbar.tpl'}{/block}

	<main class="{block name=main}container py-4{/block}">
		{block name=flash}
			{if isset($message) && $message != ''}
				<div class="alert alert-info alert-dismissible fade show d-print-none" role="status">
					<i class="bi bi-info-circle me-1"></i> {$message}
					<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
				</div>
			{/if}
		{/block}
		{block name=content}{/block}
	</main>

	<script src="js/jquery-3.7.1.min.js"></script>
	<script src="js/jquery.validate.min.js"></script>
	<script src="bootstrap/js/bootstrap.bundle.min.js"></script>
	<script src="js/giftreg.js"></script>
	{block name=scripts}{/block}
</body>
</html>
