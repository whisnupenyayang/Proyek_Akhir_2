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
    
    <!-- Custom Responsive Styles -->
    <style>
        /* Desktop/Web Chart Improvements */
        @media (min-width: 769px) {
            .chart-container {
                padding: 30px 20px;
                margin: 20px 0;
                position: relative;
                min-height: 450px;
                
            }
            
            #hargaChart {
                height: 400px !important;
                max-height: 400px !important;
            }
            
            .card-body {
                padding: 25px 30px;
            }
            
            .card-header {
                padding: 20px 30px 15px;
                border-bottom: 1px solid #dee2e6;
            }
            
            .card-header h3.card-title {
                font-size: 1.2rem;
                font-weight: 600;
                margin: 0;
                color: #495057;
            }
            
            /* Better spacing for desktop small boxes */
            .small-box {
                margin-bottom: 25px;
                box-shadow: 0 0 3px rgba(0,0,0,0.1);
            }
            
            .small-box .inner {
                padding: 20px;
            }
            
            .small-box .inner h3 {
                font-size: 2.2rem;
                margin-bottom: 8px;
                font-weight: 700;
            }
            
            .small-box .inner p {
                font-size: 1rem;
                margin-bottom: 0;
                font-weight: 500;
            }
            
            /* Content spacing for desktop */
            .content-wrapper {
                padding: 0;
            }
            
            .content {
                padding: 20px 30px;
            }
            
            .container-fluid {
                padding: 0 15px;
            }
            
            /* Chart card specific improvements */
            .chart-card {
                margin-top: 30px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
                border: none;
                border-radius: 8px;
            }
            
            .chart-card .card-header {
                background-color: #f8f9fa;
                border-radius: 8px 8px 0 0;
            }
        }
        
        /* Mobile Chart Improvements */
        @media (max-width: 768px) {
            .chart-container {
                padding: 10px;
                margin: 10px 0;
                position: relative;
            }
            
            #hargaChart {
                max-height: 300px !important;
                height: 300px !important;
            }
            
            .card-body {
                padding: 15px 10px;
            }
            
            .card-header h3.card-title {
                font-size: 0.95rem;
                margin: 0;
                line-height: 1.3;
            }
            
            /* Small box improvements for mobile */
            .small-box {
                margin-bottom: 15px;
            }
            
            .small-box .inner h3 {
                font-size: 1.8rem;
                margin-bottom: 5px;
            }
            
            .small-box .inner p {
                font-size: 0.9rem;
                margin-bottom: 0;
            }
            
            /* Content spacing adjustments */
            .content-wrapper {
                padding: 0;
            }
            
            .content {
                padding: 0 10px;
            }
            
            .container-fluid {
                padding: 0 5px;
            }
            
            /* Row spacing */
            .row {
                margin-left: -7.5px;
                margin-right: -7.5px;
            }
            
            .row > [class*="col-"] {
                padding-left: 7.5px;
                padding-right: 7.5px;
            }
        }
        
        @media (max-width: 576px) {
            #hargaChart {
                max-height: 250px !important;
                height: 250px !important;
            }
            
            .card-header h3.card-title {
                font-size: 0.85rem;
                line-height: 1.2;
            }
            
            .small-box .inner h3 {
                font-size: 1.5rem;
            }
            
            .small-box .inner p {
                font-size: 0.8rem;
            }
            
            .content {
                padding: 0 5px;
            }
        }
        
        /* Chart responsive enhancements */
        .chart-responsive {
            position: relative;
            overflow: hidden;
        }
        
        .chart-responsive canvas {
            max-width: 100% !important;
            height: auto !important;
        }
        
        /* Additional mobile optimizations */
        @media (max-width: 768px) {
            .content-header .container-fluid {
                padding: 0 15px;
            }
            
            .content-header h1 {
                font-size: 1.5rem;
            }
            
            .breadcrumb {
                font-size: 0.875rem;
            }
            
            .breadcrumb-item + .breadcrumb-item::before {
                padding-right: 0.25rem;
                padding-left: 0.25rem;
            }
        }
        
        /* Large desktop improvements */
        @media (min-width: 1200px) {
            .chart-container {
                padding: 40px 30px;
                min-height: 500px;
            }
            
            #hargaChart {
                height: 450px !important;
                max-height: 450px !important;
            }
            
            .content {
                padding: 30px 40px;
            }
            
            .card-body {
                padding: 30px 40px;
            }
            
            .card-header {
                padding: 25px 40px 20px;
            }
        }
    </style>
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
                    <div class="card chart-card">
                        <div class="card-header">
                            <h3 class="card-title">Grafik Rata-Rata Harga Kopi per Bulan ({{ date('Y') }})</h3>
                        </div>
                        <div class="card-body">
                            <div class="chart-container">
                                <canvas id="hargaChart"></canvas>
                            </div>
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

            // Check device type
            const isMobile = window.innerWidth <= 768;
            const isSmallMobile = window.innerWidth <= 576;
            const isLargeDesktop = window.innerWidth >= 1200;

            const chartConfig = {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Rata-Rata Harga Kopi (Rp)',
                        data: dataRataHarga,
                        backgroundColor: 'rgba(60,141,188,0.9)',
                        borderColor: 'rgba(60,141,188,1)',
                        borderWidth: isMobile ? 0 : 1,
                        borderRadius: isMobile ? 2 : 6,
                        borderSkipped: false,
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: true,
                            position: 'top',
                            labels: {
                                font: {
                                    size: isMobile ? 11 : isLargeDesktop ? 14 : 13
                                },
                                padding: isMobile ? 10 : isLargeDesktop ? 25 : 20,
                                usePointStyle: true,
                                pointStyle: 'rect'
                            }
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    return 'Rp ' + context.parsed.y.toLocaleString('id-ID');
                                }
                            },
                            titleFont: {
                                size: isMobile ? 11 : 13
                            },
                            bodyFont: {
                                size: isMobile ? 10 : 12
                            },
                            backgroundColor: 'rgba(0,0,0,0.8)',
                            borderColor: 'rgba(60,141,188,1)',
                            borderWidth: 1
                        }
                    },
                    scales: {
                        x: {
                            grid: {
                                display: false
                            },
                            ticks: {
                                font: {
                                    size: isSmallMobile ? 9 : isMobile ? 10 : isLargeDesktop ? 13 : 12
                                },
                                maxRotation: isMobile ? 45 : 0,
                                minRotation: isMobile ? 45 : 0,
                                padding: isMobile ? 5 : isLargeDesktop ? 15 : 12,
                                color: '#495057'
                            }
                        },
                        y: {
                            beginAtZero: true,
                            grid: {
                                color: 'rgba(0,0,0,0.1)',
                                drawBorder: false,
                                lineWidth: 1
                            },
                            ticks: {
                                font: {
                                    size: isSmallMobile ? 9 : isMobile ? 10 : isLargeDesktop ? 13 : 12
                                },
                                padding: isMobile ? 5 : isLargeDesktop ? 15 : 12,
                                color: '#495057',
                                callback: function(value) {
                                    if (isMobile) {
                                        return 'Rp ' + (value/1000) + 'k';
                                    }
                                    return 'Rp ' + value.toLocaleString('id-ID');
                                }
                            },
                            title: {
                                display: !isMobile,
                                text: 'Harga (Rp)',
                                font: {
                                    size: isLargeDesktop ? 14 : 13,
                                    weight: '600'
                                },
                                color: '#495057'
                            }
                        }
                    },
                    layout: {
                        padding: {
                            top: isMobile ? 10 : isLargeDesktop ? 25 : 20,
                            bottom: isMobile ? 10 : isLargeDesktop ? 25 : 20,
                            left: isMobile ? 5 : isLargeDesktop ? 20 : 15,
                            right: isMobile ? 5 : isLargeDesktop ? 20 : 15
                        }
                    },
                    elements: {
                        bar: {
                            borderWidth: isMobile ? 0 : 1
                        }
                    },
                    interaction: {
                        intersect: false,
                        mode: 'index'
                    }
                }
            };

            const chart = new Chart(ctx, chartConfig);

            // Handle window resize for better responsiveness
            let resizeTimeout;
            window.addEventListener('resize', function() {
                clearTimeout(resizeTimeout);
                resizeTimeout = setTimeout(function() {
                    const newIsMobile = window.innerWidth <= 768;
                    const newIsSmallMobile = window.innerWidth <= 576;
                    const newIsLargeDesktop = window.innerWidth >= 1200;
                    
                    // Update chart options for new screen size
                    chart.options.plugins.legend.display = true;
                    chart.options.plugins.legend.labels.font.size = newIsMobile ? 11 : newIsLargeDesktop ? 14 : 13;
                    chart.options.plugins.legend.labels.padding = newIsMobile ? 10 : newIsLargeDesktop ? 25 : 20;
                    chart.options.scales.y.title.display = !newIsMobile;
                    chart.options.scales.x.ticks.font.size = newIsSmallMobile ? 9 : newIsMobile ? 10 : newIsLargeDesktop ? 13 : 12;
                    chart.options.scales.y.ticks.font.size = newIsSmallMobile ? 9 : newIsMobile ? 10 : newIsLargeDesktop ? 13 : 12;
                    chart.options.scales.x.ticks.maxRotation = newIsMobile ? 45 : 0;
                    chart.options.scales.x.ticks.minRotation = newIsMobile ? 45 : 0;
                    chart.options.scales.x.ticks.padding = newIsMobile ? 5 : newIsLargeDesktop ? 15 : 12;
                    chart.options.scales.y.ticks.padding = newIsMobile ? 5 : newIsLargeDesktop ? 15 : 12;
                    chart.options.layout.padding.top = newIsMobile ? 10 : newIsLargeDesktop ? 25 : 20;
                    chart.options.layout.padding.bottom = newIsMobile ? 10 : newIsLargeDesktop ? 25 : 20;
                    chart.options.layout.padding.left = newIsMobile ? 5 : newIsLargeDesktop ? 20 : 15;
                    chart.options.layout.padding.right = newIsMobile ? 5 : newIsLargeDesktop ? 20 : 15;
                    chart.options.elements.bar.borderWidth = newIsMobile ? 0 : 1;
                    chart.data.datasets[0].borderRadius = newIsMobile ? 2 : 6;
                    chart.data.datasets[0].borderWidth = newIsMobile ? 0 : 1;
                    
                    // Update Y-axis callback for mobile formatting
                    chart.options.scales.y.ticks.callback = function(value) {
                        if (newIsMobile) {
                            return 'Rp ' + (value/1000) + 'k';
                        }
                        return 'Rp ' + value.toLocaleString('id-ID');
                    };
                    
                    chart.update('resize');
                }, 250);
            });
        });
    </script>

</body>
</html>