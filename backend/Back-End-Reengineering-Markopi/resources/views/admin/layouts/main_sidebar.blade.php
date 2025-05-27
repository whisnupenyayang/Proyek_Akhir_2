<!-- Brand Logo -->
<a href="index3.html" class="brand-link">
    <img src="{{ asset('template/dist/img/markopi.png') }}" alt="markopi" class="brand-image img-circle elevation-3"
        style="opacity: .8">
    <span class="brand-text font-weight-light">Markopi</span>
</a>

<!-- Sidebar -->
<div class="sidebar">
    <!-- Sidebar user panel (optional) -->
    <div class="user-panel mt-3 pb-3 mb-3 d-flex">
        <div class="image">
            <img src="{{ asset('template/dist/img/user2-160x160.jpg') }}" class="img-circle elevation-2"
                alt="User Image">
        </div>
        <div class="info">
            <a href="#" class="d-block">Admin Markopi</a>
        </div>
    </div>

    <!-- SidebarSearch Form -->
    <div class="form-inline">
        <div class="input-group" data-widget="sidebar-search">
            <input class="form-control form-control-sidebar" type="search" placeholder="Search" aria-label="Search">
            <div class="input-group-append">
                <button class="btn btn-sidebar">
                    <i class="fas fa-search fa-fw"></i>
                </button>
            </div>
        </div>
    </div>

    <!-- Sidebar Menu -->
    <nav class="mt-2">
        <ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu" data-accordion="false">
            <!-- Add icons to the links using the .nav-icon class
               with font-awesome or any other icon font library -->
            <li class="nav-item">
                <a href="/admin/dashboard" class="nav-link {{ \Route::is('dashboard') ? 'active' : '' }}">
                    <i class="">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
                            <path fill="currentColor" d="M10 20v-6h4v6h5v-8h3L12 3L2 12h3v8h5z" />
                        </svg>
                    </i>
                    <p>
                        Beranda
                    </p>
                </a>
            </li>

            <li class="nav-item">
                <a href="{{ route('kegiatan.budidaya') }}" class="nav-link {{ \Route::is('kegiatan.budidaya') ? 'active' : '' }}">
                    <i class="">
                        <img src="{{ asset('Icon/coffee-plant-white.png') }}" alt="Budidaya" width="24" height="24">
                    </i>
                    <p>Budidaya Kopi</p>
                </a>
            </li>




            <!-- Panen -->
            <li class="nav-item">
                <a href="{{ route('kegiatan.panen') }}" class="nav-link {{ \Route::is('kegiatan.panen') ? 'active' : '' }}">
                    <i class="">
                        <img src="{{ asset('Icon/coffee-bag-white.png') }}" alt="Panen" width="24" height="24">
                    </i>
                    <p>Panen Kopi</p>
                </a>
            </li>

            <!-- Pasca Panen -->
            <li class="nav-item">
                <a href="{{ route('kegiatan.pascapanen') }}" class="nav-link {{ \Route::is('kegiatan.pascapanen') ? 'active' : '' }}">
                    <i class="">
                        <img src="{{ asset('Icon/coffee-bean-white.png') }}" alt="Pasca Panen" width="24" height="24">
                    </i>
                    <p>Pasca Panen Kopi</p>
                </a>
            </li>
            <!-- menu sebelumnya -->
            <!--
             <li class="nav-item">
                <a href="/minuman" class="nav-link {{ \Route::is('minuman.index') ? 'active' : '' }}">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"
                        viewBox="0 0 640 512"><!--!Font Awesome Free 6.5.2 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.-->
            <!--
                        <path fill="white"
                            d="M96 64c0-17.7 14.3-32 32-32H448h64c70.7 0 128 57.3 128 128s-57.3 128-128 128H480c0 53-43 96-96 96H192c-53 0-96-43-96-96V64zM480 224h32c35.3 0 64-28.7 64-64s-28.7-64-64-64H480V224zM32 416H544c17.7 0 32 14.3 32 32s-14.3 32-32 32H32c-17.7 0-32-14.3-32-32s14.3-32 32-32z" />
                    </svg>
                    <p>
                        Minuman
                    </p>
                </a>
            </li>
            
             -->

            <!-- menu sebelumnya -->

            <li class="nav-item">
                <a href="{{ route('iklan.index') }}" class="nav-link {{ \Route::is('iklan.index') ? 'active' : '' }}">
                    <i class="">
                        <img src="{{ asset('Icon/money-bag-white.png') }}" alt="Budidaya" width="24" height="24">
                    </i>
                    <p>Iklan</p>
                </a>
            </li>

            <li class="nav-item">
                <a href="{{ route('admin.pengepul') }}" class="nav-link {{ \Route::is('admin.pengepul') ? 'active' : '' }}">
                    <i class="">
                        <img src="{{ asset('Icon/coffee-bag-white.png') }}" alt="Pengepul" width="24" height="24">
                    </i>
                    <p>Pengepul</p>
                </a>
            </li>

            <li i class="nav-item">
                <a href="/pengajuan" class="nav-link {{ \Route::is('pengajuan') ? 'active' : '' }}">
                    <i class="">
                        <img src="{{ asset('Icon/lectern-white.png') }}" alt="Budidaya" width="24" height="24">
                    </i>
                    <p>
                        Pengajuan Fasilitator
                    </p>
                </a>
            </li>
            <!-- <li i class="nav-item">
                <a href="/data_user" class="nav-link {{ \Route::is('getDataUser') ? 'active' : '' }}">
                    <i class="">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 20 20">
                            <g fill="currentColor" fill-rule="evenodd" clip-rule="evenodd">
                                <path d="M4 8.25a1 1 0 1 0 0-2a1 1 0 0 0 0 2m0 2a3 3 0 1 0 0-6a3 3 0 0 0 0 6" />
                                <path
                                    d="M4.05 11a1.5 1.5 0 0 0-1.5 1.5V14a1 1 0 0 1-2 0v-1.5a3.5 3.5 0 0 1 7 0V14a1 1 0 1 1-2 0v-1.5a1.5 1.5 0 0 0-1.5-1.5M16 8.25a1 1 0 1 1 0-2a1 1 0 0 1 0 2m0 2a3 3 0 1 1 0-6a3 3 0 0 1 0 6" />
                                <path
                                    d="M15.95 11a1.5 1.5 0 0 1 1.5 1.5V14a1 1 0 1 0 2 0v-1.5a3.5 3.5 0 0 0-7 0V14a1 1 0 1 0 2 0v-1.5a1.5 1.5 0 0 1 1.5-1.5" />
                                <path
                                    d="M10.05 13.75a2.5 2.5 0 0 0-2.5 2.5v1.5a1 1 0 0 1-2 0v-1.5a4.5 4.5 0 0 1 9 0v1.5a1 1 0 1 1-2 0v-1.5a2.5 2.5 0 0 0-2.5-2.5" />
                                <path d="M10 11a1 1 0 1 0 0-2a1 1 0 0 0 0 2m0 2a3 3 0 1 0 0-6a3 3 0 0 0 0 6" />
                            </g>
                        </svg>
                    </i>
                    <p>
                        Data User
                    </p>
                </a>
            </li> -->

            <li class="nav-item">
                <a href="{{ route('artikel.index') }}" class="nav-link {{ \Route::is('artikel.index') ? 'active' : '' }}">
                    <i>
                        <img src="{{ asset('Icon/news_white.png') }}" alt="Budidaya" width="24" height="24">
                    </i>
                    <p>Artikel</p>
                </a>
            </li>


            <li i class="nav-item">
                <a href="{{ route('admin.toko') }}" class="nav-link {{ \Route::is('admin.toko') ? 'active' : '' }}">
                    <i class="">
                        <img src="{{ asset('Icon/iconoir_shop.png') }}" alt="Budidaya" width="24" height="24">
                    </i>
                    <p>Toko kopi
                    </p>
                </a>
            </li>

            <li i class="nav-item">
                <a href="{{ route('admin.resep') }}" class="nav-link {{ \Route::is('admin.resep') ? 'active' : '' }}">
                    <i class="">
                        <img src="{{ asset('Icon/line-md_coffee-half-empty-filled-loop.png') }}" alt="Budidaya" width="24" height="24">
                    </i>
                    <p>Resep minuman
                    </p>
                </a>
            </li>


        </ul>
    </nav>


    <!-- /.sidebar-menu -->
</div>
<!-- /.sidebar -->