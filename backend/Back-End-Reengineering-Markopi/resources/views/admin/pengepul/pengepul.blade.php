@extends('admin.layouts.admin')
@section('content')
<style>
    .card {
        display: flex;
        flex-direction: row;
        align-items: center;
        border: 1px solid #ddd;
        border-radius: 8px;
        margin-bottom: 20px;
        padding: 15px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        background: white;
    }
    .card img {
        width: 120px;
        height: 120px;
        object-fit: cover;
        border-radius: 8px;
        margin-right: 20px;
        flex-shrink: 0;
    }
    .card-info {
        flex: 1;
    }
    .card-info h5 {
        font-size: 18px;
        font-weight: 600;
        margin-bottom: 15px;
        color: #333;
    }
    .card-info p {
        margin: 4px 0;
        font-size: 14px;
        color: #555;
        line-height: 1.4;
    }
    .card-info strong {
        font-weight: 600;
    }
    .selengkapnya {
        display: inline-block;
        margin-top: 10px;
        font-size: 14px;
        color: #007bff;
        text-decoration: none;
    }
    .selengkapnya:hover {
        text-decoration: underline;
    }

    /* Add Button Style - sama seperti di kode iklan */
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

    @media (max-width: 768px) {
        .card {
            padding: 10px;
        }
        .card img {
            width: 100px;
            height: 100px;
            margin-right: 15px;
        }
    }
</style>

<!-- Material Icons CDN -->
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

<div class="row">
    <section class="col-lg-12 connectedSortable" style="position: relative;">
        @forelse ($pengepuls as $pengepul)
        <div class="card">
            {{-- Ganti sesuai kolom gambar yang kamu gunakan --}}
            <img src="{{ asset($pengepul->url_gambar) }}" alt="Foto Pengepul" class="img-fluid rounded mb-3" style="max-height: 300px;">
            <div class="card-info">
                <h5>{{ $pengepul->nama }}</h5>
                <p><strong>Alamat:</strong> {{ $pengepul->alamat }}</p>
                <p><strong>Jenis Kopi:</strong> {{ $pengepul->jenis_kopi }}</p>
                <p><strong>Jenis Produk:</strong> {{ $pengepul->jenis_produk }}</p>
                <p><strong>Harga/kg:</strong> Rp{{ number_format($pengepul->harga, 0, ',', '.') }}</p>
                <a href="{{ route('pengepul.show', $pengepul->id) }}" class="selengkapnya">Selengkapnya</a>
            </div>
        </div>
        @empty
        <div class="text-center text-muted">Belum ada data pengepul.</div>
        @endforelse
        
        {{-- Tombol Add Pengepul --}}
        <div style="display: flex; justify-content: flex-end; gap: 10px; margin-bottom: 20px;">
            <a href="{{ route('pengepul.create') }}" class="add-btn" title="Tambah Pengepul">
                <span class="material-icons">add</span>
            </a>
        </div>
    </section>
</div>
@endsection