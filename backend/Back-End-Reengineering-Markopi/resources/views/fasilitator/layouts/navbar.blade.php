<!-- Navbar -->

<!-- Left navbar links -->
<ul class="navbar-nav">
    <li class="nav-item">
        <a class="nav-link" data-widget="pushmenu" href="#" role="button"><i class="fas fa-bars"></i></a>
    </li>
    {{-- <li class="nav-item d-none d-sm-inline-block">
        <a href="index3.html" class="nav-link">Home</a>
    </li>
    <li class="nav-item d-none d-sm-inline-block">
        <a href="#" class="nav-link">Contact</a>
    </li> --}}
</ul>

<!-- Right navbar links -->
<ul class="navbar-nav ml-auto">
    <!-- Navbar Search -->
    {{-- <li class="nav-item">
        <a class="nav-link" data-widget="navbar-search" href="#" role="button">
            <i class="fas fa-search"></i>
        </a>
        <div class="navbar-search-block">
            <form class="form-inline">
                <div class="input-group input-group-sm">
                    <input class="form-control form-control-navbar" type="search" placeholder="Search"
                        aria-label="Search">
                    <div class="input-group-append">
                        <button class="btn btn-navbar" type="submit">
                            <i class="fas fa-search"></i>
                        </button>
                        <button class="btn btn-navbar" type="button" data-widget="navbar-search">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </li> --}}
    <!-- Notifications Dropdown Menu -->
    {{-- @php
        $pengajuans = \DB::table('pengajuans')
            ->join('users', 'pengajuans.petani_id', '=', 'users.id')
            ->select('users.username')
            ->where('status', '0')
            // ->where('petani_id', Auth::user()->id)
            ->get();
    @endphp --}}
    {{-- <div class="icon-header-item cl2 hov-cl2 trans-04 p-r-11 p-l-20 icon-header-noti js-show-cart"
        data-notify="{{ count($pengajuans)  }}">
        <i class="zmdi zmdi-notifications"></i>
    </div> --}}
    {{-- <li class="nav-item dropdown">
        <a class="nav-link" data-toggle="dropdown" href="#">
            <i class="far fa-bell"></i>
            <span class="badge badge-warning navbar-badge">{{ count($pengajuans) }}</span>
        </a>
        <div class="dropdown-menu dropdown-menu-lg dropdown-menu-right">
            <span class="dropdown-item dropdown-header">{{ count($pengajuans) }} Notifications</span>
            <div class="dropdown-divider"></div>
            <a href="{{ route('pengajuan.index') }}" class="dropdown-item">
                {{ 'Terdapat ' . count($pengajuans) . ' pengajuan dari petani' }}
            </a>
        </div>
    </li> --}}
    {{-- <li class="nav-item">
        <a class="nav-link" data-widget="fullscreen" href="#" role="button">
            <i class="fas fa-expand-arrows-alt"></i>
        </a>
    </li>
    <li class="nav-item">
        <a class="nav-link" data-widget="control-sidebar" data-controlsidebar-slide="true" href="#"
            role="button">
            <i class="fas fa-th-large"></i>
        </a>
    </li> --}}
    <form action="/logout" method="POST">
        @csrf
        <button class="dropdown-item">Logout</button>
    </form>
</ul>
<!-- /.navbar -->
