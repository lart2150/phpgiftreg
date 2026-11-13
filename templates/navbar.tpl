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

<nav class="navbar navbar-expand-lg sticky-top gr-navbar d-print-none">
	<div class="container">
		<a class="navbar-brand" href="index.php"><i class="bi bi-gift-fill me-1"></i> Gift Registry</a>
		<button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#main-menu" aria-controls="main-menu" aria-expanded="false" aria-label="Toggle navigation">
			<span class="navbar-toggler-icon"></span>
		</button>
		<div id="main-menu" class="collapse navbar-collapse">
			<ul class="navbar-nav me-auto">
				<li class="nav-item"><a class="nav-link {if $currentpage == 'index'}active{/if}" href="index.php"><i class="bi bi-house"></i>Home</a></li>
				<li class="nav-item"><a class="nav-link {if $currentpage == 'shoplist'}active{/if}" href="shoplist.php"><i class="bi bi-cart3"></i>My Shopping List</a></li>
				<li class="nav-item"><a class="nav-link {if $currentpage == 'mylist'}active{/if}" href="mylist.php"><i class="bi bi-printer"></i>My Items (printable)</a></li>
			</ul>
			<ul class="navbar-nav">
				<li class="nav-item"><a class="nav-link {if $currentpage == 'event'}active{/if}" href="event.php" title="Events"><i class="bi bi-calendar-event"></i><span class="nav-text">Events</span></a></li>
				<li class="nav-item"><a class="nav-link {if $currentpage == 'profile'}active{/if}" href="profile.php" title="Profile"><i class="bi bi-person-circle"></i><span class="nav-text">Profile</span></a></li>
				{if $isadmin}
					<li class="nav-item dropdown">
						<a class="nav-link dropdown-toggle {if $currentpage|in_array:['users', 'families', 'categories', 'ranks']}active{/if}" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
							<i class="bi bi-shield-lock"></i>Admin
						</a>
						<ul class="dropdown-menu dropdown-menu-end">
							<li><a class="dropdown-item" href="users.php"><i class="bi bi-people me-2"></i>Manage Users</a></li>
							<li><a class="dropdown-item" href="families.php"><i class="bi bi-house-heart me-2"></i>Manage Families</a></li>
							<li><a class="dropdown-item" href="categories.php"><i class="bi bi-tags me-2"></i>Manage Categories</a></li>
							<li><a class="dropdown-item" href="ranks.php"><i class="bi bi-star me-2"></i>Manage Ranks</a></li>
						</ul>
					</li>
				{/if}
				<li class="nav-item"><a class="nav-link" href="login.php?csrf={$csrf}&action=logout" title="Logout"><i class="bi bi-box-arrow-right"></i><span class="nav-text">Logout</span></a></li>
			</ul>
		</div>
	</div>
</nav>
