@extends('admin.layouts.admin')

@section('content')
    <style>
        .card-resep {
            display: flex;
            flex-direction: column;
            margin-bottom: 20px;
            border: 1px solid #ddd;
            padding: 10px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            background: white;
        }

        .card-resep img {
            width: 100%;
            height: auto;
            object-fit: cover;
            border-radius: 8px;
            margin-bottom: 10px;
        }

        .card-resep-content {
            padding: 0;
            text-align: center;
        }

        .card-resep-content h5 {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 6px;
            color: #333;
        }

        .card-resep-content p {
            font-size: 14px;
            color: #555;
            margin: 4px 0;
        }

        .btn-detail {
            font-size: 14px;
            color: white;
            background-color: #007bff;
            padding: 6px 12px;
            border-radius: 5px;
            text-decoration: none;
            display: inline-block;
            margin-top: 8px;
        }

        .btn-detail:hover {
            background-color: #0056b3;
        }

        @media (min-width: 768px) {
            .card-resep {
                flex-direction: row;
                align-items: center;
                gap: 20px;
            }

            .card-resep img {
                width: 200px;
                height: 150px;
                margin-bottom: 0;
            }

            .card-resep-content {
                text-align: left;
                flex: 1;
            }
        }

        @media (max-width: 767px) {
            .card-resep {
                flex-direction: row;
                align-items: center;
            }

            .card-resep img {
                width: 100px;
                height: 100px;
                margin-bottom: 0;
                border-radius: 8px;
                object-fit: cover;
                flex-shrink: 0;
            }

            .card-resep-content {
                padding-left: 15px;
                text-align: left;
                flex: 1;
            }

            .card-resep-content h5 {
                font-size: 16px;
                margin-bottom: 4px;
            }

            .card-resep-content p {
                font-size: 13px;
            }

            .btn-detail {
                font-size: 13px;
                padding: 5px 10px;
            }
        }
    </style>

    <h1>{{ $title }}</h1>

    @if (session('success'))
        <div class="alert alert-success">
            {{ session('success') }}
        </div>
    @endif

    <div class="container">
        @foreach ($resep as $t)
            <div class="card-resep">
                @if ($t->gambar_resep)
                    <img src="{{ asset('images/' . $t->gambar_resep) }}" alt="Foto resep">
                @else
                    <div style="width:100px; height:100px; background:#f0f0f0; border-radius:8px; display:flex; align-items:center; justify-content:center; color:#888; font-size:12px;">
                        Tidak ada gambar
                    </div>
                @endif

                <div class="card-resep-content">
                    <h5>{{ $t->nama_resep }}</h5>
                    <p>{{ $t->deskripsi_resep }}</p>
                    <a href="{{ route('resep.detail', $t->id) }}" class="btn-detail">Detail</a>
                </div>
            </div>
        @endforeach

        <div style="display: flex; justify-content: flex-end; gap: 10px; margin-bottom: 20px; margin-top: 10px;">
            <a href="{{ route('resep.create') }}" class="btn btn-success">
                Tambah Resep
            </a>
        </div>
    </div>
@endsection
