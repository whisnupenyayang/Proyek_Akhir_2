@extends('admin.layouts.admin')

@section('content')
<style>
    .card-body {
        display: flex;
        flex-direction: column;
        padding: 15px;
    }

    .card img {
        max-width: 100%;
        height: auto;
        border-radius: 5px;
        object-fit: cover;
    }

    .card {
        margin-bottom: 20px;
        border-radius: 5px;
        overflow: hidden;
    }

    .card .row {
        display: flex;
        flex-direction: row;
        align-items: stretch;
    }

    .card-title {
        font-size: 20px;
        font-weight: bold;
        margin-bottom: 10px;
    }

    .card-text {
        font-size: 15px;
        line-height: 1.6;
    }

    .text-link {
        font-size: 14px;
        color: #007bff;
        text-decoration: none;
        display: inline-block;
        margin-top: 10px;
    }

    .text-link:hover {
        text-decoration: underline;
    }

    .btn-tambah {
        margin-top: 30px;
        text-align: center;
    }

    .btn-tambah a {
        padding: 10px 20px;
        background-color: #28a745;
        color: white;
        border-radius: 4px;
        text-decoration: none;
        font-weight: 500;
        transition: background-color 0.3s;
    }

    .btn-tambah a:hover {
        background-color: #218838;
    }

    @media (max-width: 768px) {
        .card-body {
            padding: 10px;
        }

        .card .row {
            flex-direction: row !important;
        }

        .col-md-3 {
            max-width: 40%;
            padding-right: 10px;
        }

        .col-md-9 {
            max-width: 60%;
        }

        .card-title {
            font-size: 16px;
        }

        .card-text {
            font-size: 14px;
        }

        .text-link {
            width: 100%;
            text-align: left;
        }

        .btn-tambah {
            margin-top: 20px;
        }

        .btn-tambah a {
            width: 100%;
            display: block;
        }
    }
</style>

<div class="row">
    <section class="col-lg-12 connectedSortable">
        <div class="card-body">
            @forelse ($tahapanByKegiatan as $kegiatan => $items)
                <h4 class="text-primary">{{ $kegiatan }}</h4> <!-- Menampilkan kegiatan -->

                @foreach ($items as $tahapan)
                <div class="card w-100">
                    <div class="row g-0">
                        <div class="col-md-3">
                            <img src="{{ asset('img/kopi.jpg') }}" alt="Ilustrasi Kopi" class="profile-img">
                        </div>
                        <div class="col-md-9">
                            <div class="card-body">
                                <h5 class="card-title">{{ $tahapan->nama_tahapan }}</h5>
                                <p class="card-text">
                                    <strong>Jenis Kopi:</strong> {{ $tahapan->jenis_kopi }}<br>
                                    <strong>Kegiatan:</strong> {{ $tahapan->kegiatan }}
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
                @endforeach
            @empty
                <div class="text-center text-muted">Belum ada data tahapan kegiatan.</div>
            @endforelse

            <div class="btn-tambah">
                <a href="{{ route('tahapan.create') }}">+ Tambah Tahapan</a>
            </div>
        </div>
    </section>
</div>
@endsection
