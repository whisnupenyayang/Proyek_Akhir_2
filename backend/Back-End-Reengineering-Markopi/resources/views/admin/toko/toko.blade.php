@extends('admin.layouts.admin')

@section('content')
    <style>
        .btn-tambah-wrapper {
            margin-bottom: 10px;
            display: flex;
            justify-content: flex-start;
        }

        .toko-container {
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 15px;
            background: white;
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
        }

        .card-toko {
            display: flex;
            flex-direction: column;
            margin-bottom: 20px;
            border: none;
            box-shadow: none;
            padding: 0;
            border-radius: 0;
            width: 100%;
            background: transparent;
            border-bottom: 1px solid #a5a3a3; /* garis pembatas */
            padding-bottom: 15px;
        }

        /* Hilangkan garis pembatas untuk card terakhir agar tidak double border */
        .card-toko:last-child {
            border-bottom: none;
            margin-bottom: 0;
            padding-bottom: 0;
        }

        .card-toko img {
            width: 100%;
            height: auto;
            object-fit: cover;
            border-radius: 8px;
            margin-bottom: 10px;
        }

        .card-toko-content {
            padding: 0;
            text-align: center;
        }

        .card-toko-content h5 {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 6px;
            color: #333;
        }

        .card-toko-content p {
            font-size: 14px;
            color: #555;
            margin: 4px 0;
        }

        .btn-detail {
            font-size: 14px;
            color: white;
            background-color: #17a2b8;
            padding: 6px 12px;
            border-radius: 5px;
            text-decoration: none;
            display: inline-block;
            margin-top: 8px;
        }

        .btn-detail:hover {
            background-color: #138496;
        }

        @media (min-width: 768px) {
            .card-toko {
                flex-direction: row;
                align-items: center;
                gap: 20px;
            }

            .card-toko img {
                width: 200px;
                height: 150px;
                margin-bottom: 0;
            }

            .card-toko-content {
                text-align: left;
                flex: 1;
            }
        }

        @media (max-width: 767px) {
            .card-toko {
                flex-direction: row;
                align-items: center;
            }

            .card-toko img {
                width: 100px;
                height: 100px;
                margin-bottom: 0;
                border-radius: 8px;
                object-fit: cover;
                flex-shrink: 0;
            }

            .card-toko-content {
                padding-left: 15px;
                text-align: left;
                flex: 1;
            }

            .card-toko-content h5 {
                font-size: 16px;
                margin-bottom: 4px;
            }

            .card-toko-content p {
                font-size: 13px;
            }

            .btn-detail {
                font-size: 13px;
                padding: 5px 10px;
            }
        }
    </style>

    @if(session('success'))
        <div class="alert alert-success">
            {{ session('success') }}
        </div>
    @endif

    <div class="container">
        <div class="btn-tambah-wrapper">
            <a href="{{ route('toko.create') }}" class="btn btn-primary">
                Tambah Toko
            </a>
        </div>

        <div class="toko-container">
            @forelse ($toko as $t)
                <div class="card-toko">
                    @if ($t->foto_toko)
                        <img src="{{ asset('images/' . $t->foto_toko) }}" alt="Foto Toko">
                    @else
                        <div style="width:100px; height:100px; background:#f0f0f0; border-radius:8px; display:flex; align-items:center; justify-content:center; color:#888; font-size:12px;">
                            Tidak ada gambar
                        </div>
                    @endif

                    <div class="card-toko-content">
                        <h5>{{ $t->nama_toko }}</h5>
                        <p><strong>Lokasi:</strong> {{ $t->lokasi }}</p>
                        <p><strong>Jam Operasional:</strong> {{ $t->jam_operasional }}</p>
                        <a href="{{ route('toko.detail', $t->id) }}" class="btn-detail">Detail</a>
                    </div>
                </div>
            @empty
                <div class="text-center py-4 text-muted" style="font-size: 16px;">
                    Belum ada data toko.
                </div>
            @endforelse

        </div>
    </div>
@endsection
