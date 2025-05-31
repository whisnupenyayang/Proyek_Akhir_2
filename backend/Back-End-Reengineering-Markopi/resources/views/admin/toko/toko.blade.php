@extends('admin.layouts.admin')

@section('content')
    <style>
        .toko-container {
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 15px;
            background: white;
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
            max-width: 900px;
            margin: 0 auto;
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
            border-bottom: 1px solid #a5a3a3;
            padding-bottom: 15px;
        }

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

        .read-more-link {
            font-size: 14px;
            color: #007bff;
            text-decoration: none;
            user-select: none;
            display: inline-block;
            margin-top: 8px;
        }

        .read-more-link:hover {
            text-decoration: underline;
        }

        .add-btn {
            background-color: #004085;
            color: white;
            padding: 10px 14px;
            border-radius: 50%;
            text-align: center;
            text-decoration: none;
            font-size: 24px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            transition: background-color 0.3s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .add-btn:hover {
            background-color: #003366;
            color: white;
            text-decoration: none;
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

            .read-more-link {
                font-size: 15px;
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

            .read-more-link {
                font-size: 13px;
            }
        }
    </style>

    <!-- Material Icons CDN -->
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

    @if(session('success'))
        <div class="alert alert-success">
            {{ session('success') }}
        </div>
    @endif

    <div class="container">
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
                        <a href="{{ route('toko.detail', $t->id) }}" class="read-more-link">Selengkapnya</a>
                    </div>
                </div>
            @empty
                <div class="text-center py-4 text-muted" style="font-size: 16px;">
                    Belum ada data toko.
                </div>
            @endforelse
        </div> {{-- Penutup toko-container --}}

        {{-- Tombol Tambah Toko di luar card dan di bawah --}}
        <div style="display: flex; justify-content: flex-end; gap: 10px; margin-top: 20px;">
            <a href="{{ route('toko.create') }}" class="add-btn" title="Tambah Toko">
                <span class="material-icons">add</span>
            </a>
        </div>
    </div>
@endsection
