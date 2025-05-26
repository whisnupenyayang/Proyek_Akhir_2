<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Admin Kopi | Dashboard</title>

    <!-- Google Font: Source Sans Pro -->
    <link rel="stylesheet"
        href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="{{ asset('template/plugins/fontawesome-free/css/all.min.css') }}">
    <!-- Theme style -->
    <link rel="stylesheet" href="{{ asset('template/dist/css/adminlte.min.css') }}">
</head>

<body class="hold-transition sidebar-mini layout-fixed">
    <div class="wrapper">

        <!-- Preloader -->
        <div class="preloader flex-column justify-content-center align-items-center">
            <img class="animation__shake" src="{{ asset('template/dist/img/markopi.png') }}" alt="AdminLTELogo"
                height="300" width="300">
        </div>

        <!-- Navbar -->
        <nav class="main-header navbar navbar-expand navbar-white navbar-light">
            @include('admin.layouts.navbar')
        </nav>

        <!-- Sidebar -->
        <aside class="main-sidebar sidebar-dark-primary elevation-4">
            @include('admin.layouts.main_sidebar')
        </aside>

        <!-- Content Wrapper -->
        <div class="content-wrapper">

            <!-- Header -->
            <div class="content-header">
                <div class="container-fluid">
                    <div class="row mb-2">
                        <div class="col-sm-6">
                            <h1 class="m-0">Dashboard</h1>
                        </div>
                        <div class="col-sm-6">
                            <ol class="breadcrumb float-sm-right">
                                <li class="breadcrumb-item"><a href="#">Beranda</a></li>
                                <li class="breadcrumb-item active">Dashboard</li>
                            </ol>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Main content -->
            <section class="content">
                <div class="container-fluid">

                    <div class="alert alert-warning text-center font-weight-bold">
                        🚀 INI HALAMAN DASHBOARD UTAMA!
                    </div>

                    <!-- Info Card Row -->
                    <div class="row">

                        <!-- Total Pengepul -->
                        <div class="col-lg-3 col-6">
                            <div class="small-box bg-success">
                                <div class="inner">
                                    <h3>{{ $totalPengepul }}</h3>
                                    <p>Total Pengepul</p>
                                </div>
                                <div class="icon">
                                    <i class="fas fa-store"></i>
                                </div>
                            </div>
                        </div>

                        <!-- Total Iklan -->
                        <div class="col-lg-3 col-6">
                            <div class="small-box bg-info">
                                <div class="inner">
                                    <h3>{{ $totalIklan }}</h3>
                                    <p>Total Iklan</p>
                                </div>
                                <div class="icon">
                                    <i class="fas fa-bullhorn"></i>
                                </div>
                            </div>
                        </div>

                    </div>

                    <!-- Grafik Harga Rata-Rata -->
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">Grafik Rata-Rata Harga Kopi per Bulan ({{ date('Y') }})</h3>
                        </div>
                        <div class="card-body">
                            <canvas id="hargaChart" height="100"></canvas>
                        </div>
                    </div>

                </div>
            </section>

        </div>

        <!-- Footer -->
        <footer class="main-footer">
            @include('admin.layouts.footer')
        </footer>

        <!-- Control Sidebar -->
        <aside class="control-sidebar control-sidebar-dark"></aside>

    </div>

    <!-- Script JS -->
    <script src="{{ asset('template/plugins/jquery/jquery.min.js') }}"></script>
    <script src="{{ asset('template/plugins/bootstrap/js/bootstrap.bundle.min.js') }}"></script>
    <script src="{{ asset('template/plugins/chart.js/Chart.min.js') }}"></script>
    <script src="{{ asset('template/dist/js/adminlte.min.js') }}"></script>

    <!-- Grafik Harga Script -->
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const ctx = document.getElementById('hargaChart').getContext('2d');

            const labels = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
            const dataRataHarga = Array(12).fill(0);

            const avgPerMonth = {!! json_encode($avgPerMonth) !!};
            avgPerMonth.forEach(item => {
                dataRataHarga[item.bulan - 1] = parseFloat(item.rata_harga);
            });

            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Rata-Rata Harga Kopi (Rp)',
                        data: dataRataHarga,
                        backgroundColor: 'rgba(60,141,188,0.9)',
                        borderColor: 'rgba(60,141,188,1)',
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    scales: {
                        y: {
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: 'Harga (Rp)'
                            }
                        }
                    }
                }
            });
        });
    </script>

</body>
</html>
