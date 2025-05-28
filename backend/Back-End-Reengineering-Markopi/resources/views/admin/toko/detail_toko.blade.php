@extends('admin.layouts.admin')

@section('title', 'Detail Toko')

@section('content')
    <style>
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background-color: white;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
        }

        h1 {
            text-align: center;
            margin-bottom: 20px;
        }

        .btn-back {
            margin-bottom: 15px;
            font-size: 1.2em;
        }

        .detail-card {
            background-color: #f9f9f9;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }

        .detail-card img {
            width: 100%;
            height: auto;
            border-radius: 8px;
        }

        .field-container {
            margin-bottom: 15px;
        }

        .action-buttons {
            display: flex;
            justify-content: flex-end;
            margin-top: 20px;
        }

        .btn-trash {
            background-color: #f44336;
            color: white;
            border: none;
            padding: 10px 16px;
            font-size: 1.2em;
            border-radius: 50%;
            cursor: pointer;
        }

        .btn-trash:hover {
            background-color: #d32f2f;
        }

        .btn-trash i {
            font-size: 1.5em;
        }
    </style>

    <div class="container">



        <div class="detail-card">
            <!-- Nama Toko -->
            <div class="field-container">
                <h3 id="toko-name">{{ $toko->nama_toko }}</h3>
            </div>

            <!-- Lokasi Toko -->
            <div class="field-container">
                <p id="toko-lokasi"><strong>Lokasi:</strong>
                    <a href="{{ $toko->lokasi }}" target="_blank">{{ $toko->lokasi }}</a>
                </p>
            </div>

            <!-- Jam Operasional -->
            <div class="field-container">
                <p id="toko-jam"><strong>Jam Operasional:</strong> {{ $toko->jam_operasional }}</p>
            </div>

            <!-- Deskripsi -->
            <div class="field-container">
                <p id="toko-desc"><strong>Deskripsi:</strong> {{ $toko->deskripsi }}</p>
            </div>

            <!-- Foto Toko -->
            <div class="field-container">
                @if ($toko->foto_toko)
                    <img id="current-image" src="{{ asset('images/' . $toko->foto_toko) }}" alt="Foto Toko">
                @else
                    <p>Tidak ada foto toko.</p>
                @endif
            </div>
        </div>

        <!-- Tombol Aksi -->
        <div class="action-buttons">
            <form action="{{ route('toko.destroy', $toko->id) }}" method="POST">
                @csrf
                @method('DELETE')
                 <button type="submit" class="btn btn-danger">Hapus</button>
            </form>
        </div>
    </div>
@endsection
